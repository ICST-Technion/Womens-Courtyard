client fields content:

| Field | Type | Part of | Client Permissions | Staff Permissions |
| --- | --- | --- | --- | --- |
| ID | String | Client | R | RW |
| name | String | Client | R | RW |
| personal file | Object | Client | N/A | RW |
| client notes | List[String] | Personal File | N/A | RW |
| appointment history | List[Appointment] | Client | R | RW |

Appointment fields content (per client)

| Field | Type | Part of | Client Permissions | Staff Permissions |
| --- | --- | --- | --- | --- |
| appointment name | String | appointment | R | RW |
| date | String | appointment | R | RW |
| location | String | appointment | R | RW |
| staff in charge | String | appointment | N/A | RW |

Roles fields content

| Field | Type | Part of | Client Permissions | Staff Permissions |
| --- | --- | --- | --- | --- |
| username | String | User | N/A | RW |
| role | String | User | N/A | RC |

staff fields content:

| Field | Type | Part of | Client Permissions | Staff Permissions |
| --- | --- | --- | --- | --- |
| id | String | staff | N/A | RC |
| name | String | staff | N/A | RW |

&quot;specified client&quot; condition:

match /users/{userId}/\&lt;FIELD HERE\&gt; {

allow read: if request.auth != null &amp;&amp; request.auth.uid == userId

}