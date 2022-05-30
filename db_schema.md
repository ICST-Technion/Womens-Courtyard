# Current Permission Version (restrictive + staff-only users)

## **client fields content**
### key: Some hash
| Field | Type | Part of | Client Permissions | Staff Permissions |
| --- | --- | --- | --- | --- |
| firstName | String | Client | N/A | RW same branch |
| lastName | String | Client | N/A | RW same branch |
| idNo | String (optional) | Client | N/A | RW same branch |
| age | Int | Client | N/A | RW same branch |
| address | String | Client | N/A | RW same branch |
| phoneNo | String | Client | N/A | RW same branch |
| nationality | String (optional) | Client | N/A | RW same branch |
| branch | String | Client | N/A | RW same branch |
| clientNotes | Array[String] | Client | N/A | RW same branch |
| inAssignment | Boolean | Client | N/A | RW same branch |
| processes | Array[String] | Client | N/A | RW same branch |
| appointmentHistory | Array[Appointment] | Client | N/A | RW same branch |
| attendances | Array[Attendance] | Client | N/A | RW same branch |


## **attendance fields content (per client):**
| Field | Type | Part of | Client Permissions | Staff Permissions |
| --- | --- | --- | --- | --- |
| date | Timestamp | attendance | N/A | RW same branch |
| comment | String | attendance | N/A | RW same branch |


## **appointment fields content (per client)**
| Field | Type | Part of | Client Permissions | Staff Permissions |
| --- | --- | --- | --- | --- |
| description | String | appointment | N/A | RW same branch |
| date | Timestamp | appointment | N/A | RW same branch |
| location | String | appointment | N/A | RW same branch |
| staffInCharge | String | appointment | N/A | RW same branch |

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
| name | String | staff | N/A | R Same User, C(reate)|


## **Contacts fields content**
### key: some hash
| Field | Type | Part of | Client Permissions | Staff Permissions |
| --- | --- | --- | --- | --- |
| firstName | String | Contact | N/A | RW same branch |
| lastName | String | Contact | N/A | RW same branch |
| field | String | Contact | N/A | RW same branch |
| phoneNo | String | Contact | N/A | RW same branch |
| email | String | Contact | N/A | RW same branch |
| info | String | Contact | N/A | RW same branch |
