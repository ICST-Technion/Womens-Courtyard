### **client fields content:**
### key: user ID
| Field | Type | Part of | Client Permissions | Staff Permissions |
| --- | --- | --- | --- | --- |
| name | String | Client | R | RW |
| personal file | Object | Client | N/A | RW |
| client notes | List[String] | Personal File | N/A | RW |
| appointment history | List[Appointment] | Client | R | RW |
<!-- | ID | String | Client | R | RW | -->

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

<!-- | username | String | staff | N/A | RC | -->



&quot;specified client&quot; condition:

match /users/{userId}/\&lt;FIELD HERE\&gt; {

allow read: if request.auth != null &amp;&amp; request.auth.uid == userId

}