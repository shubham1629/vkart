import { AssetsField, ASSETS_TABLENAME } from "./table";

const INSERT = {
    key: "QU1",
    type: "I",
    query: `INSERT INTO ${ASSETS_TABLENAME}(
        ${AssetsField.OWNER_ID}, ${AssetsField.SECONDARY_OWNER}, ${AssetsField.SECONDARY_OWNER_TYPE},
        ${AssetsField.CREATED_ON}, ${AssetsField.CREATED_BY}, ${AssetsField.STATUS},
        ${AssetsField.NAME}, ${AssetsField.URL}, ${AssetsField.LOCAL_PATH})
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`
        };


export const UserQueries = Object.freeze({ INSERT });