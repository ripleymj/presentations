---
marp: true

---
# Databases

- Tonight's agenda:
  - History/overview
  - Analytic functions
  - JSON duality
  - Query planning and optimization

---
# A brief history

- Flat files - available on every computer ever
- Hierarchical - data stored in a tree
  - Biggest example is the Windows Registry
- Network model - similar to hierarchical, but children can have multiple parents
  - Standardized in 1969, and largely abandoned in the 80's
- Relational model - data stored as records in tables, with relationships between columns of the tables
- Object oriented - outgrowth of relational databases that specialize in object persistence

---
# Where we are today

- Relational databases won over their predecessors
- Object oriented have larged faded
- NoSQL/document databases are becoming popular
  - Simplified prototyping, relaxed reliability constraints
- Graph databases (storing nodes, edges, properties) an area of research and investment
- Vector databases rising within the AI world
- Hybrid databases combining technologies

---
# Four essential acronyms - (R)DBMS

- Relational
- DataBase
- Management
- System

---
# Four essential acronyms - ACID

Why use a database?

- Atomicity
- Consistency
- Isolation
- Durability

---
# Atomicity

- Requires that database modifications must follow an "all or nothing" rule. Each transaction is said to be atomic if when one part of the transaction fails, the entire transaction fails and database state is left unchanged.

# Consistency

- Ensures that the database remains in a consistent state; more precisely, it says that any transaction will take the database from one consistent state to another consistent state. When rules are defined between database tables, no data is allowed that violates those rules.

---
# Isolation

Isolation refers to the requirement that other operations cannot access or see data that has been modified during a transaction that has not yet completed.

# Durability

The ability of the DBMS to recover the committed transaction updates against any kind of system failure (hardware or software). Durability is the DBMS's guarantee that once the user has been notified of a transaction's success, the transaction will not be lost.

---
# Four essential acronyms - CRUD

The four essential SQL operations

- Create
- Retrieve (select)
- Update
- Delete

---
# Four essential acronyms - SQL

- Structured
- Query
- Language

---
# So how do databases store information?

- Tables!
  - Rows for each entity
  - Columns for each attribute
- "Data normalization" to keep things from becoming a mess
  - Do not store duplicated data
  - Define separate tables and link them together by unique IDs

---
![bg contain](image01.png)

---
![bg contain](image02.png)

---
# Let's do some queries

```sql
SELECT * FROM employees;
```

```sql
SELECT first_name, last_name from EMPLOYEES;
```

```sql
SELECT * FROM employees
WHERE employee_id = 100;
```

```sql
SELECT * FROM employees
ORDER BY hire_date DESC;
```

---
# Let's do some queries

```sql
SELECT count(*) FROM employees;
```

```sql
SELECT DISTINCT job_id FROM employees;
```

```sql
SELECT job_id, count(*) from EMPLOYEES
GROUP by job_id;
```

```sql
SELECT job_id, count(*) from EMPLOYEES
GROUP by job_id
HAVING count(*) > 5;
```

---
# Let's do some queries

```sql
SELECT * FROM jobs;
```

```sql
SELECT e.first_name, e.last_name, j.job_title
FROM employees e, jobs j
WHERE e.job_id = j.job_id
ORDER BY job_title;
```

---
# Let's do some queries

```sql
SELECT e.first_name, e.last_name,
d.department_name, l.state_province, c.country_name

FROM employees e, departments d, locations l, countries c

WHERE e.department_id = d.department_id
AND d.location_id = l.location_id
AND l.country_id = c.country_id

ORDER BY country_name, state_province;
```

---
# Analytic functions

[oracle-base](https://oracle-base.com/articles/misc/analytic-functions)

---
# JSON duality

- As a response to the document/NoSQL database movement, the relational world has responded with hybrid databases
- JSON data types allow clients to put/get JSON documents, much like document DBs
- JSON functions/schema allow JSON data to be ingested into part of the regular query engine
- JSON formatting functions allow clients to run SQL and receive the results as JSON

---
# JSON in the Database

- Almost all databases have BLOB/CLOB support for arbitrary attachments
- Postgres adds two new types: `json` and `jsonb`
- Both validate the json is well-formed
- `json` stores the exact json text - faster to load, slower to parse
- `jsonb` stores a parsed binary representation - slower to load, faster to search
- [`pg_jsonschema`](https://github.com/supabase/pg_jsonschema) extension allows a check-constraint to be defined for a column
- `jsonb` allows indexing, either of the whole document or specific attributes
- [`jsonpath`](https://github.com/obartunov/sqljsondoc/blob/master/jsonpath.md) syntax allows querying documents inside SQL statements

---
# JSON from the database

- In addition to retreiving json data you've stored, [json functions](https://www.postgresql.org/docs/current/functions-json.html) can create documents from traditional relational data
  - `row_to_json()`
  - `json_agg()`
  - `json_object_agg()`

---
# An intro to the query optimizer
