const { app, BrowserWindow, ipcMain } = require('electron')
const url = require("url");
const path = require("path");
const fs = require('fs');

const dbPath = path.join(__dirname, "/db/data2.db");
const nowdate = new Date();
const dateStr = nowdate.getFullYear() + '-' + nowdate.getMonth() + '-' + nowdate.getDate();
const dbLogPath = path.join(__dirname, `/log/db/log_${dateStr}`);

const preparedStatments = {};

function writeDBLog(message) {
    fs.appendFile(dbLogPath.toString(), message, function (err, file) {
        if (err)
            console.error(err);
    });
}

function logQuery(query, res, err) {
    writeDBLog(`{\n\tdatetime: ${new Date()}\n\tquery: ${query}\n\tres: ${JSON.stringify(res)}\n\terr: ${JSON.stringify(err)}\n}\n`);
}


writeDBLog(`\n******************************************************************************
            \nStarting DB at ${new Date()}
            \n******************************************************************************`);


let mainWindow

function createWindow() {
    mainWindow = new BrowserWindow({
        width: 800,
        height: 600,
        webPreferences: {
            nodeIntegration: true,
            contextIsolation: false
        }
    })

    mainWindow.loadURL(
        url.format({
            pathname: path.join(__dirname, `/dist/vkart-app/index.html`),
            protocol: "file:",
            slashes: true
        })
    );
    // Open the DevTools.
    mainWindow.webContents.openDevTools()
    mainWindow.on('closed', function () {
        mainWindow = null;
    })
}

app.on('ready', createWindow)

app.on('window-all-closed', function () {
    if (process.platform !== 'darwin') app.quit();
    closeDB();
});

app.on('activate', function () {
    if (mainWindow === null) createWindow()
});

const sqlite3 = require('sqlite3').verbose();
const db = new sqlite3.Database(dbPath);

function closeDB() {
    db.close();
    writeDBLog(`\n******************************************************************************
                \nClosing DB at ${new Date()}
                \n******************************************************************************\n\n`);
}


ipcMain.on('select-query', function (event, query, params) {
    try {
        db.prepare(query).all(params, (err, rows) => {
            event.returnValue = rows;
            logQuery(query, rows, err);
        });
    } catch (e) {
        logQuery(query, null, e);
    }
});

ipcMain.on('update-query', function (event, query) {
    try {
        db.run(query, (res, err) => {
            event.returnValue = { res, err };
            logQuery(query, res, err);
        });
    } catch (e) {
        logQuery(query, null, e);
    }
});

ipcMain.on('close-db', function (event, query) {
    closeDB();
});

ipcMain.on('getObjects', function (event, query) {
    event.returnValue = { res, err };
});

ipcMain.on('store-prerpare-stmt', function (event, key, query, type) {
    preparedStatments[key] = { query, stmt: db.prepare(query), type };
    event.returnValue = true;
});

ipcMain.on('call-prerpare-stmt', function (event, key, params) {
    if(preparedStatments[key].type == "I") {
        preparedStatments[key].stmt.run(params, (err) => {
            event.returnValue = this.lastID;
            logQuery(preparedStatments[key].query, params, err);
        })
    } else if (preparedStatments[key].type == "S") {
        preparedStatments[key].stmt.all(params, (err, rows) => {
            event.returnValue = rows;
            logQuery(preparedStatments[key].query, rows, err);
        });
    }
});
