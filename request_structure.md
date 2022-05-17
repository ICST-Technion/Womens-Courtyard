
Sign-In request structure:

| Field | Type |
| --- | --- |
| username | string |
| password | string |


Sign-Up request structure:

| Field | Type |
| --- | --- |
| username | string |
| name  | string |
| password | string |
| role | string (staff/client) |


Login server response structure:
| Field | Type |
| --- | --- |
| success | bool |
| data | string |