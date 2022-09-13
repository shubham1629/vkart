export const USER_TABLENAME =  "User";

export enum UserField {
    ID = "id",
	FIRST_NAME = "fname",
	LAST_NAME = "lname",
	CONTACT_NUMBER = "contactNumber",
	EMAIL = "email",
	CREATED_ON = "createdOn",
	CREATED_BY = "createdBy",
	UPDATED_ON = "updatedOn",
	UPDATED_BY = "updatedBy",
	STATUS = "status",
	PROFILE_PIC = "profilePic",
	ADDRESS_ID = "addressId"
}



export const ADDRESS_TABLENAME =  "Address";

export enum AddressField {
    ID = "id",
	PINCODE = "pincode",
	FULL_ADRESS = "fullAddress",
	STATUS = "status",
	COUNT = "count",
	CREATED_ON = "createdOn",
	CREATED_BY = "createdBy",
	UPDATE_ON = "updatedOn",
	UPDATE_BY = "updatedBy"
}




export const MESSAGES_TABLENAME =  "Messages";

export enum MessagesField {
    ID = "id",
	OWNER_ID = "ownerId",
	SECONDARY_OWNER = "secondaryOwner",
	SECONDARY_OWNER_TYPE = "secondaryOwnerType",
	TEXT = "text",
	STATUS = "status",
	CREATED_ON = "createdOn",
	CREATED_BY = "createdBy",
	UPDATE_ON = "updatedOn",
	UPDATE_BY = "updatedBy"
}


export const ASSETS_TABLENAME =  "Assets";

export enum AssetsField {
    ID = "id",
	OWNER_ID = "ownerId",
	SECONDARY_OWNER = "secondaryOwner",
	SECONDARY_OWNER_TYPE = "secondaryOwnerType",
	NAME = "name",
	STATUS = "status",
	URL = "url",
	CREATED_ON = "createdOn",
	CREATED_BY = "createdBy",
	UPDATE_ON = "updatedOn",
	UPDATE_BY = "updatedBy",
	LOCAL_PATH = "localPath"
}