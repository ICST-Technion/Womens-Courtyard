## Ideal Permissions Version

### **client fields content:**
### key: user ID
| Field | Type | Part of | Client Permissions | Staff Permissions |
| --- | --- | --- | --- | --- |
| name | String | Client | R | RW |
| ID number | String | Client | N/A | RW |
| personal file | Object | Client | N/A | RW |
| client notes | List[String] | Personal File | N/A | RW |
| appointment history | List[Appointment] | Client | R | RW |

### **appointment fields content (per client)**
| Field | Type | Part of | Client Permissions | Staff Permissions |
| --- | --- | --- | --- | --- |
| appointment name | String | appointment | R | RW |
| date | String | appointment | R | RW |
| location | String | appointment | R | RW |
| staff in charge | String | appointment | N/A | RW |


### **users fields content**
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


### **staff fields content:**
### key: user ID
| Field | Type | Part of | Client Permissions | Staff Permissions |
| --- | --- | --- | --- | --- |
| name | String | staff | N/A | RW |



## Current Permission Version (restrictive + staff-only users)

### **client fields content:**
### key: ID number
| Field | Type | Part of | Client Permissions | Staff Permissions |
| --- | --- | --- | --- | --- |
| name | String | Client | N/A | RW |
| ID number | String | Client | N/A | RW |
| Phone number | String | Client | N/A | RW |
| personal file | Object | Client | N/A | RW |
| client notes | List[String] | Personal File | N/A | RW |
| appointment history | List[Appointment] | Client | N/A | RW |

### **appointment fields content (per client)**
| Field | Type | Part of | Client Permissions | Staff Permissions |
| --- | --- | --- | --- | --- |
| appointment name | String | appointment | N/A | RW |
| date | String | appointment | N/A | RW |
| location | String | appointment | N/A | RW |
| staff in charge | String | appointment | N/A | RW |


### **users fields content**
### key: user ID
| Field | Type | Part of | Client Permissions | Staff Permissions |
| --- | --- | --- | --- | --- |
| username | String | User | N/A | N/A |
| password | String | User | N/A | N/A |
| role | String | User | N/A | N/A |



### **staff fields content:**
### key: user ID
| Field | Type | Part of | Client Permissions | Staff Permissions |
| --- | --- | --- | --- | --- |
| name | String | staff | N/A | RW |