import { AddressField, ADDRESS_TABLENAME, MESSAGES_TABLENAME } from "./table";

const INSERT = {
    key: "QU1",
    type: "I",
    query: `INSERT INTO ${ADDRESS_TABLENAME}(
        ${AddressField.PINCODE}, ${AddressField.COUNT}, ${AddressField.CREATED_BY},
        ${AddressField.CREATED_ON}, ${AddressField.FULL_ADRESS}, ${AddressField.STATUS})
        VALUES (?, ?, ?, ?, ?, ?)`
        };


export const UserQueries = Object.freeze({ INSERT });