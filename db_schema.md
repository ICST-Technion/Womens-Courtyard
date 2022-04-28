# Ideal Permissions Version

## **client fields content:**
### key: user ID
| Field | Type | Part of | Client Permissions | Staff Permissions |
| --- | --- | --- | --- | --- |
| name | String | Client | R | RW |
| ID number | String | Client | N/A | RW |
| personal file | Object | Client | N/A | RW |
| client notes | List[String] | Personal File | N/A | RW |
| appointment history | List[Appointment] | Client | R | RW |

## **appointment fields content (per client)**
| Field | Type | Part of | Client Permissions | Staff Permissions |
| --- | --- | --- | --- | --- |
| appointment name | String | appointment | R | RW |
| date | String | appointment | R | RW |
| location | String | appointment | R | RW |
| staff in charge | String | appointment | N/A | RW |


## **users fields content**
### key: user ID
| Field | Type | Part of | Client Permissions | Staff Permissions |
| --- | --- | --- | --- | --- |
| username | String | User | N/A | RW |
| password | String | User | N/A | N/A |
| role | String | User | N/A | N/A |

<!-- ### **ids fields content**
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
| first name | String | Client | N/A | RW |
| last name | String | Client | N/A | RW |
| ID number | String (optional) | Client | N/A | RW |
| Phone number | String | Client | N/A | RW |
| Nationality | String (optional) | Client | N/A | RW
| personal file | Personal File | Client | N/A | RW |
| appointments | List[Appointment] | Client | N/A | RW |
| attendances | List[Attendance] | Client | N/A | RW |

<!-- Broke away to new table -->
<!-- TBD: new fields may be added -->
## **Personal File fields content (per client)**
| Field | Type | Part of | Client Permissions | Staff Permissions |
| --- | --- | --- | --- | --- |
| client notes | List[String] | Personal File | N/A | RW |

<!-- Broke away to new table -->
## **attendance fields content (per client):**
| Field | Type | Part of | Client Permissions | Staff Permissions |
| --- | --- | --- | --- | --- |
| date | timestamp | attendance | N/A | RW |
| comment | String | attendance | N/A | RW |


<!-- Added description, removed name -->
<!-- Changed date to timestamp -->
## **appointment fields content (per client)**
| Field | Type | Part of | Client Permissions | Staff Permissions |
| --- | --- | --- | --- | --- |
| description | String (optional) | appointment | N/A | RW |
| date | timestamp | appointment | N/A | RW |
| location | String | appointment | N/A | RW |
| staff in charge | String | appointment | N/A | RW |

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


## **contacts fields content**
### key: some hash
| Field | Type | Part of | Client Permissions | Staff Permissions |
| --- | --- | --- | --- | --- |
| firstName | String | contact | N/A | RW |
| lastName | String | contact | N/A | RW |
| field | String | contact | N/A | RW |
| phoneNo | String | contact | N/A | RW |
| email | String | contact | N/A | RW |
