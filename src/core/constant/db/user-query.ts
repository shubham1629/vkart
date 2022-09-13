import { AddressField, ADDRESS_TABLENAME, AssetsField, ASSETS_TABLENAME, UserField, USER_TABLENAME } from "./table";

const INSERT = {
    key: "QU1",
    type: "I",
    query: `INSERT INTO ${USER_TABLENAME}(
        ${UserField.FIRST_NAME}, ${UserField.LAST_NAME}, ${UserField.CONTACT_NUMBER},
        ${UserField.EMAIL}, ${UserField.STATUS}, ${UserField.CREATED_ON}, ${UserField.CREATED_BY},
        ${UserField.PROFILE_PIC}, ${UserField.ADDRESS_ID})
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`
        };


const SELECT_ALL= {
        key: "QU4",
        type: "S",
        query: `SELECT 
            u.${UserField.ID} id, 
            u.${UserField.FIRST_NAME} firstName,
            u.${UserField.LAST_NAME} lastName,
            u.${UserField.CONTACT_NUMBER} contactNumber,
            u.${UserField.EMAIL} email,
            u.${UserField.STATUS} status,
            u.${UserField.CREATED_ON} createdOn,
            u.${UserField.CREATED_BY} createdBy,
            u.${UserField.UPDATED_BY} updatedBy,
            u.${UserField.UPDATED_ON} updatedOn,
            f.${AssetsField.URL} profilePicURL,
            a.${AddressField.PINCODE} pincode,
            a.${AddressField.FULL_ADRESS} fullAddress
        FROM ${USER_TABLENAME} u
            LEFT OUTER JOIN ${ASSETS_TABLENAME} f 
                ON u.${UserField.PROFILE_PIC} = f.${AssetsField.ID}
            LEFT OUTER JOIN ${ADDRESS_TABLENAME} a
                ON u.${UserField.ADDRESS_ID} = a.${AddressField.ID}`
            };

const SELECT_BY_ID = {
        key: "QU5",
        type: "S",
        query: `${SELECT_ALL.query}
        WHERE
            u.id = ?`
        };

const SELECT_ALL_PAGINATION = {
        key: "QU6",
        type: "S",
        query: `${SELECT_ALL.query}
        LIMIT ? OFFSET ?`
    };

const COUNT_ALL = {
        key: "QU7",
        type: "S",
        query: `SELECT
            COUNT(1) count
        FROM ${USER_TABLENAME}`
    };


export const UserQueries = Object.freeze({ INSERT, SELECT_ALL, SELECT_BY_ID, SELECT_ALL_PAGINATION, COUNT_ALL});