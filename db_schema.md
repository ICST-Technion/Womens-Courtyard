<!-- # Ideal Permissions Version

## **client fields content:**
### key: user ID
| Field | Type | Part of | Client Permissions | Staff Permissions |
| --- | --- | --- | --- | --- |
| name | String | Client | R | RW |
| ID number | String | Client | N/A | RW |
| personal file | Map | Client | N/A | RW |
| client notes | Array[String] | Personal File | N/A | RW |
| appointment history | Array[Appointment] | Client | R | RW |

## **appointment fields content (per client)**
| Field | Type | Part of | Client Permissions | Staff Permissions |
| --- | --- | --- | --- | --- |
| appointment name | String | appointment | R | RW |
| date | Timestamp | appointment | R | RW |
| location | String | appointment | R | RW |
| staff in charge | String | appointment | N/A | RW |


## **users fields content**
### key: user ID
| Field | Type | Part of | Client Permissions | Staff Permissions |
| --- | --- | --- | --- | --- |
| username | String | User | N/A | RW |
| password | String | User | N/A | N/A |
| role | String | User | N/A | N/A | 

### **ids fields content**
### key: username
| Field | Type | Part of | Client Permissions | Staff Permissions |
| --- | --- | --- | --- | --- |
| id | string | user | N/A | N/A | -->


## **staff fields content**
### key: user ID
| Field | Type | Part of | Client Permissions | Staff Permissions |
| --- | --- | --- | --- | --- |
| name | String | staff | N/A | RW |



# Current Permission Version (restrictive + staff-only users)

## **client fields content**
### key: Some hash
| Field | Type | Part of | Client Permissions | Staff Permissions |
| --- | --- | --- | --- | --- |
| firstName | String | Client | N/A | RW |
| lastName | String | Client | N/A | RW |
| idNo | String (optional) | Client | N/A | RW |
| age | Int | Client | N/A | RW |
| address | String | N/A | RW |
| phoneNo | String | Client | N/A | RW |
| nationality | String (optional) | Client | N/A | RW |
| clientNotes | Array[String] | Client | N/A | RW |
| inAssignment | Boolean | Client | N/A | RW |
| processes | Array[String] | Client | N/A | RW |
| appointmentHistory | Array[Appointment] | Client | N/A | RW |
| attendances | Array[Attendance] | Client | N/A | RW |


## **attendance fields content (per client):**
| Field | Type | Part of | Client Permissions | Staff Permissions |
| --- | --- | --- | --- | --- |
| date | Timestamp | attendance | N/A | RW |
| comment | String | attendance | N/A | RW |


## **appointment fields content (per client)**
| Field | Type | Part of | Client Permissions | Staff Permissions |
| --- | --- | --- | --- | --- |
| description | String | appointment | N/A | RW |
| date | Timestamp | appointment | N/A | RW |
| location | String | appointment | N/A | RW |
| staffInCharge | String | appointment | N/A | RW |

## **users fields content**
### key: username
| Field | Type | Part of | Client Permissions | Staff Permissions |
| --- | --- | --- | --- | --- |
| username | String | User | N/A | N/A |
| password | String | User | N/A | N/A |
| role | String | User | N/A | N/A |

## **staff fields content:**
### key: username
| Field | Type | Part of | Client Permissions | Staff Permissions |
| --- | --- | --- | --- | --- |
| name | String | staff | N/A | RW |


## **Contacts fields content**
### key: some hash
| Field | Type | Part of | Client Permissions | Staff Permissions |
| --- | --- | --- | --- | --- |
| firstName | String | Contact | N/A | RW |
| lastName | String | Contact | N/A | RW |
| field | String | Contact | N/A | RW |
| phoneNo | String | Contact | N/A | RW |
| email | String | Contact | N/A | RW |
| info | String | Contact | N/A | RW |
