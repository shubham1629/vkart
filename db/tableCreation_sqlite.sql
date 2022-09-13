-- import to SQLite by running: sqlite3.exe db.sqlite3 -init sqlite.sql




CREATE TABLE `User` (
	`id` INTEGER PRIMARY KEY AUTOINCREMENT,
	`fname` VARCHAR(128),
	`lname` VARCHAR(128),
	`contactNumber` CHAR(20) NOT NULL,
	`email` VARCHAR(255) NOT NULL,
	`createdOn` DATETIME NOT NULL,
	`createdBy` INT NOT NULL,
	`updatedOn` DATETIME,
	`updatedBy` INT,
	`status` CHAR(10),
	`profilePic` INT,
	`addressId` VARCHAR(1024)
);
CREATE INDEX `User_addressIndex` ON `User` (`addressId`);
CREATE INDEX `User_createdOnIndex` ON `User` (`createdOn`);


CREATE TABLE `Address` (
	`id` INTEGER PRIMARY KEY AUTOINCREMENT,
	`pincode` CHAR(20),
	`count` INT DEFAULT 0,
	`createdOn` DATETIME NOT NULL,
	`createdBy` INT NOT NULL,
	`updatedOn` DATETIME,
	`updatedBy` INT,
	`fullAddress` VARCHAR(512),
	`status` CHAR(10)
);
CREATE INDEX `Address_pinCodeIndex` ON `Address` (`pincode`);



CREATE TABLE `Category` (
	`id` INTEGER PRIMARY KEY AUTOINCREMENT,
	`name` VARCHAR(255),
	`parentId` INT,
	`count` INT DEFAULT 0,
	`status` CHAR(10),
	`createdOn` DATETIME NOT NULL,
	`createdBy` INT NOT NULL,
	`updatedOn` DATETIME,
	`updatedBy` INT,
	`description` TEXT
);
CREATE INDEX `Category_parentIndex` ON `Category` (`parentId`);
CREATE INDEX `Category_statusIndex` ON `Category` (`status`);


CREATE TABLE `Brand` (
	`id` INTEGER PRIMARY KEY AUTOINCREMENT,
	`name` VARCHAR(255),
	`count` INT DEFAULT 0,
	`status` CHAR(10),
	`parentId` INT,
	`createdOn` DATETIME NOT NULL,
	`createdBy` INT NOT NULL,
	`updatedOn` DATETIME,
	`updatedBy` INT,
	`description` TEXT
);
CREATE INDEX `Brand_parentIndex` ON `Brand` (`parentId`);
CREATE INDEX `Brand_statusIndex` ON `Brand` (`status`);


CREATE TABLE `Product` (
	`id` INTEGER PRIMARY KEY AUTOINCREMENT,
	`productCode` VARCHAR(50),
	`categoryId` INT NOT NULL,
	`name` VARCHAR(255),
	`rating` INT,
	`price` INT,
	`qty` INT,
	`brandId` INT,
	`createdOn` DATETIME NOT NULL,
	`createdBy` INT NOT NULL,
	`updatedOn` DATETIME,
	`updatedBy` INT,
	`count` INT DEFAULT 0,
	`status` CHAR(10)
);
CREATE INDEX `Product_categoryIndex` ON `Product` (`categoryId`);
CREATE INDEX `Product_brandIndex` ON `Product` (`brandId`);
CREATE INDEX `Product_brandCategoryIndex` ON `Product` (`categoryId`, `brandId`);
CREATE INDEX `Product_createdOnIndex` ON `Product` (`createdOn`);
CREATE INDEX `Product_productPriceIndex` ON `Product` (`price`);
CREATE INDEX `Product_productCodeIndex` ON `Product` (`productCode`);
CREATE INDEX `Product_productCodeIndex` ON `Product` (`count`);


CREATE TABLE `Messages` (
	`id` INTEGER PRIMARY KEY AUTOINCREMENT,
	`ownerId` INT,
	`secondaryOwner` INT,
	`secondaryOwnerType` CHAR(1),
	`createdOn` DATETIME NOT NULL,
	`createdBy` INT NOT NULL,
	`updatedOn` DATETIME,
	`updatedBy` INT,
	`status` CHAR(10),
	`text` VARCHAR(4096)
);
CREATE INDEX `Messages_secondaryOwnerIndex` ON `Messages` (`secondaryOwner`,`secondaryOwnerType`);


CREATE TABLE `Assets` (
	`id` INTEGER PRIMARY KEY AUTOINCREMENT,
	`ownerId` INT,
	`secondaryOwner` INT,
	`secondaryOwnerType` CHAR(1),
	`createdOn` DATETIME NOT NULL,
	`createdBy` INT NOT NULL,
	`updatedOn` DATETIME,
	`updatedBy` INT,
	`status` CHAR(10),
	`name` VARCHAR(255),
	`localPath` VARCHAR(4096),
	`url` VARCHAR(4096)
);
CREATE INDEX `Assets_secondaryOwnerIndex` ON `Assets` (`secondaryOwner`,`secondaryOwnerType`);

CREATE TABLE `Order` (
	`id` INTEGER PRIMARY KEY AUTOINCREMENT,
	`productId` INT,
	`userId` INT,
	`price` INT,
	`payedAmount` INT,
	`profit` INT,
	`expectedDays` INT,
	`createdOn` DATETIME NOT NULL,
	`createdBy` INT NOT NULL,
	`updatedOn` DATETIME,
	`updatedBy` INT,
	`status` CHAR(10),
	`addressId` int,
	`parentId` int
);
CREATE INDEX `Order_productIndex` ON `Order` (`productId`);
CREATE INDEX `Order_userIndex` ON `Order` (`userId`);
CREATE INDEX `Order_productUserIndex` ON `Order` (`userId`, `productId`);
CREATE INDEX `Order_updatedDateIndex` ON `Order` (`updatedOn`);


CREATE TABLE `History` (
	`id` INTEGER PRIMARY KEY AUTOINCREMENT,
	`createdOn` DATETIME,
	`createdBy` INT,
	`objectId` INT,
	`objectType` CHAR(2),
	`action` CHAR(2),
	`fieldName` CHAR(40),
	`parentId` BIGINT,
	`oldValue` VARCHAR(4096),
	`newValue` VARCHAR(4096)
);
CREATE INDEX `History_createdOn` ON `History` (`createdOn`);



CREATE TABLE `dual` (`val` INTEGER);
INSERT INTO `dual` (val) VALUES (1);

CREATE TRIGGER dual_lock_insert AFTER INSERT ON `dual`
BEGIN
	SELECT RAISE (FAIL, 'Can still find old address, not everything was updated!');
END;

CREATE TRIGGER dual_lock_delete AFTER DELETE ON `dual`
BEGIN
	SELECT RAISE (FAIL, 'Can still find old address, not everything was updated!');
END;


CREATE TRIGGER dual_lock_update AFTER UPDATE ON `dual`
BEGIN
	SELECT RAISE (FAIL, 'Can still find old address, not everything was updated!');
END;



	
CREATE VIRTUAL TABLE `user_fts` USING fts5( `fname`,`lname`,`email`,`contactNumber`);


CREATE TRIGGER user_Insert AFTER INSERT ON user
BEGIN
    INSERT INTO user_fts (rowid, fname, lname, email, contactNumber) VALUES (new.id, new.fname, new.lname, new.email, new.contactNumber);
    INSERT INTO History (createdOn, createdBy, objectId, objectType, action) VALUES (datetime('now'), new.createdBy, new.id, 'U', 'I');
END;

CREATE TRIGGER user_Delete AFTER DELETE ON user
BEGIN
    DELETE FROM user_fts WHERE rowid=old.id;
    INSERT INTO History (createdOn, createdBy, objectId, objectType, action) VALUES (datetime('now'), new.createdBy, new.id, 'U', 'D');
END;


CREATE TRIGGER user_Update AFTER UPDATE ON user
BEGIN
	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
			select datetime('now'),new.updatedBy, new.id, 'U', 'U', old.fname, new.fname, 'fname' from dual 
				where new.fname != old.fname;
	
	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
		select datetime('now'),new.updatedBy, new.id, 'U', 'U', old.lname, new.lname, 'lname' from dual 
			where new.lname != old.lname;
	
	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
		select datetime('now'),new.updatedBy, new.id, 'U', 'U', old.contactNumber, new.contactNumber, 'contactNumber' from dual 
			where new.contactNumber != old.contactNumber;

	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
		select datetime('now'),new.updatedBy, new.id, 'U', 'U', old.email, new.email, 'email' from dual 
			where new.email != old.email;

	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
		select datetime('now'),new.updatedBy, new.id, 'U', 'U', old.status, new.status, 'status' from dual 
			where new.status != old.status;

	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
		select datetime('now'),new.updatedBy, new.id, 'U', 'U', old.addressId, new.addressId, 'addressId' from dual 
			where new.addressId != old.addressId;	
	
	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
		select datetime('now'),new.updatedBy, new.id, 'U', 'U', old.profilePic, new.profilePic, 'profilePic' from dual 
			where new.profilePic != old.profilePic;
			
	Update user_fts 
    	SET fname = new.fname,
	     lname = new.lname,
	     email = new.email,
       	     contactNumber =  new.contactNumber
     	WHERE rowid = new.id;
END;


CREATE TRIGGER category_Insert AFTER INSERT ON Category
BEGIN
    INSERT INTO History (createdOn, createdBy, objectId, objectType, action) VALUES (datetime('now'), new.createdBy, new.id, 'C', 'I');
END;

CREATE TRIGGER category_Delete AFTER DELETE ON Category
BEGIN
    INSERT INTO History (createdOn, createdBy, objectId, objectType, action) VALUES (datetime('now'), new.createdBy, new.id, 'C', 'D');
END;


CREATE TRIGGER category_Update AFTER UPDATE ON Category
BEGIN
	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
			select datetime('now'),new.updatedBy, new.id, 'C', 'U', old.name, new.name, 'name' from dual 
				where new.name != old.name;
	
	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
		select datetime('now'),new.updatedBy, new.id, 'C', 'U', old.count, new.count, 'count' from dual 
			where new.count != old.count;
	
	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
		select datetime('now'),new.updatedBy, new.id, 'C', 'U', old.status, new.status, 'status' from dual 
			where new.status != old.status;

	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
		select datetime('now'),new.updatedBy, new.id, 'C', 'U', old.description, new.description, 'description' from dual 
			where new.description != old.description;
	
	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
		select datetime('now'),new.updatedBy, new.id, 'C', 'U', old.parentId, new.parentId, 'parentId' from dual 
			where new.parentId != old.parentId;
END;


CREATE TRIGGER product_Insert AFTER INSERT ON Product
BEGIN
    INSERT INTO History (createdOn, createdBy, objectId, objectType, action) VALUES (datetime('now'), new.createdBy, new.id, 'P', 'I');
END;

CREATE TRIGGER producty_Delete AFTER DELETE ON Product
BEGIN
    INSERT INTO History (createdOn, createdBy, objectId, objectType, action) VALUES (datetime('now'), new.createdBy, new.id, 'P', 'D');
END;


CREATE TRIGGER product_Update AFTER UPDATE ON Product
BEGIN
	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
			select datetime('now'),new.updatedBy, new.id, 'P', 'U', old.productCode, new.productCode, 'productCode' from dual 
				where new.productCode != old.productCode;
	
	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
		select datetime('now'),new.updatedBy, new.id, 'P', 'U', old.categoryId, new.categoryId, 'categoryId' from dual 
			where new.categoryId != old.categoryId;
	
	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
		select datetime('now'),new.updatedBy, new.id, 'P', 'U', old.name, new.name, 'name' from dual 
			where new.name != old.name;
			
	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
		select datetime('now'),new.updatedBy, new.id, 'P', 'U', old.rating, new.rating, 'rating' from dual 
			where new.rating != old.rating;

	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
		select datetime('now'),new.updatedBy, new.id, 'P', 'U', old.price, new.price, 'price' from dual 
			where new.price != old.price;
	
	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
		select datetime('now'),new.updatedBy, new.id, 'P', 'U', old.qty, new.qty, 'qty' from dual 
			where new.qty != old.qty;
			
	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
		select datetime('now'),new.updatedBy, new.id, 'P', 'U', old.status, new.status, 'status' from dual 
			where new.status != old.status;

	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
		select datetime('now'),new.updatedBy, new.id, 'P', 'U', old.brandId, new.brandId, 'brandId' from dual 
			where new.brandId != old.brandId;
			
END;



CREATE TRIGGER brand_Insert AFTER INSERT ON Brand
BEGIN
    INSERT INTO History (createdOn, createdBy, objectId, objectType, action) VALUES (datetime('now'), new.createdBy, new.id, 'B', 'I');
END;

CREATE TRIGGER brand_Delete AFTER DELETE ON Brand
BEGIN
    INSERT INTO History (createdOn, createdBy, objectId, objectType, action) VALUES (datetime('now'), new.createdBy, new.id, 'B', 'D');
END;


CREATE TRIGGER brand_Update AFTER UPDATE ON Brand
BEGIN
	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
		select datetime('now'),new.updatedBy, new.id, 'P', 'U', old.name, new.name, 'name' from dual 
			where new.name != old.name;

	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
		select datetime('now'),new.updatedBy, new.id, 'C', 'U', old.count, new.count, 'count' from dual 
			where new.count != old.count;

	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
		select datetime('now'),new.updatedBy, new.id, 'P', 'U', old.status, new.status, 'status' from dual 
			where new.status != old.status;
			
	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
		select datetime('now'),new.updatedBy, new.id, 'P', 'U', old.description, new.description, 'description' from dual 
			where new.description != old.description;
			
	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
		select datetime('now'),new.updatedBy, new.id, 'C', 'U', old.parentId, new.parentId, 'parentId' from dual 
			where new.parentId != old.parentId;
			
END;



CREATE TRIGGER messages_Insert AFTER INSERT ON Messages
BEGIN
    INSERT INTO History (createdOn, createdBy, objectId, objectType, action) VALUES (datetime('now'), new.createdBy, new.id, 'M', 'I');
END;

CREATE TRIGGER messages_Delete AFTER DELETE ON Messages
BEGIN
    INSERT INTO History (createdOn, createdBy, objectId, objectType, action) VALUES (datetime('now'), new.createdBy, new.id, 'M', 'D');
END;


CREATE TRIGGER messages_Update AFTER UPDATE ON Messages
BEGIN
	
	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
		select datetime('now'),new.updatedBy, new.id, 'P', 'U', old.text, new.text, 'text' from dual 
			where new.text != old.text;
	
	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
		select datetime('now'),new.updatedBy, new.id, 'P', 'U', old.status, new.status, 'status' from dual 
			where new.status != old.status;
			
END;


CREATE TRIGGER order_Insert AFTER INSERT ON `Order`
BEGIN
    INSERT INTO History (createdOn, createdBy, objectId, objectType, action) VALUES (datetime('now'), new.createdBy, new.id, 'O', 'I');
END;

CREATE TRIGGER order_Delete AFTER DELETE ON `Order`
BEGIN
    INSERT INTO History (createdOn, createdBy, objectId, objectType, action) VALUES (datetime('now'), new.createdBy, new.id, 'O', 'D');
END;


CREATE TRIGGER orders_Update AFTER UPDATE ON `Order`
BEGIN
	
	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
		select datetime('now'),new.updatedBy, new.id, 'O', 'U', old.status, new.status, 'status' from dual 
			where new.status != old.status;
			
	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
		select datetime('now'),new.updatedBy, new.id, 'O', 'U', old.expectedDays, new.expectedDays, 'expectedDays' from dual 
			where new.expectedDays != old.expectedDays;
	
	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
		select datetime('now'),new.updatedBy, new.id, 'O', 'U', old.addressId, new.addressId, 'addressId' from dual 
			where new.addressId != old.addressId;
	
	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
		select datetime('now'),new.updatedBy, new.id, 'O', 'U', old.payedAmount, new.payedAmount, 'payedAmount' from dual 
			where new.payedAmount != old.payedAmount;
	
	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
		select datetime('now'),new.updatedBy, new.id, 'O', 'U', old.price, new.price, 'price' from dual 
			where new.price != old.price;
			
END;


CREATE TRIGGER address_Insert AFTER INSERT ON Address
BEGIN
    INSERT INTO History (createdOn, createdBy, objectId, objectType, action) VALUES (datetime('now'), new.createdBy, new.id, 'A', 'I');
END;

CREATE TRIGGER address_Delete AFTER DELETE ON Address
BEGIN
    INSERT INTO History (createdOn, createdBy, objectId, objectType, action) VALUES (datetime('now'), new.createdBy, new.id, 'A', 'D');
END;

CREATE TRIGGER address_Update AFTER UPDATE ON Address
BEGIN
	
	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
		select datetime('now'),new.updatedBy, new.id, 'A', 'U', old.status, new.status, 'status' from dual 
			where new.status != old.status;
	
	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
		select datetime('now'),new.updatedBy, new.id, 'A', 'U', old.fullAddress, new.fullAddress, 'fullAddress' from dual 
			where new.fullAddress != old.fullAddress;
	
	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
		select datetime('now'),new.updatedBy, new.id, 'A', 'U', old.count, new.count, 'count' from dual 
			where new.count != old.count;
END;



CREATE TRIGGER assets_Insert AFTER INSERT ON Assets
BEGIN
    INSERT INTO History (createdOn, createdBy, objectId, objectType, action) VALUES (datetime('now'), new.createdBy, new.id, 'F', 'I');
END;

CREATE TRIGGER assets_Delete AFTER DELETE ON Assets
BEGIN
    INSERT INTO History (createdOn, createdBy, objectId, objectType, action) VALUES (datetime('now'), new.createdBy, new.id, 'F', 'D');
END;


CREATE TRIGGER assets_Update AFTER UPDATE ON Assets
BEGIN
	
	INSERT INTO History (createdOn, createdBy, objectId, objectType, action, oldValue, newValue, fieldName) 
		select datetime('now'),new.updatedBy, new.id, 'F', 'U', old.status, new.status, 'status' from dual 
			where new.status != old.status;
			
END;


