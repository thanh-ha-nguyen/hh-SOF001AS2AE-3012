# Database Transaction Exercises Resolution

## Task 1: Creating a table for testing

```sql
-- Create the Account table
CREATE TABLE Account (
 accountNumber INT NOT NULL,
 balance INT NOT NULL DEFAULT 0,
 CONSTRAINT PK_Account PRIMARY KEY (accountNumber)
);

-- Insert test data into the Account table
INSERT INTO Account (accountNumber, balance) VALUES (1, 1000);
INSERT INTO Account (accountNumber, balance) VALUES (2, 1000);

SELECT accountNumber, balance FROM Account;
```

---

## Task 2: Transaction basics

```sql
BEGIN TRANSACTION;
DELETE FROM Account;
SELECT * FROM Account;
ROLLBACK;
SELECT * FROM Account;
```

**Answers:**
1. 0 rows.
2. 2 rows.

---

## Task 3

```sql
BEGIN TRANSACTION;
INSERT INTO Account (accountNumber, balance) VALUES (3, 1000);
INSERT INTO Account (accountNumber, balance) VALUES (4, 1000);
UPDATE Account SET balance = 40 WHERE accountNumber = 4;
SELECT * FROM Account;
ROLLBACK;
SELECT * FROM Account;
```

**Answers:**
1. 2040 (1000 + 1000 + 1000 + 40).
2. 2000 (Original two accounts).

---

## Task 4

```sql
BEGIN TRANSACTION;
INSERT INTO Account (accountNumber, balance) VALUES (3, 1000);
SELECT * FROM Account;
UPDATE Account SET balance = 20 WHERE accountNumber = 3;
SELECT * FROM Account; 
COMMIT;
SELECT * FROM Account;
```

**Answers:**
1. 3000 (1000 + 1000 + 1000).
2. 2020 (1000 + 1000 + 20).

---

## Task 5: Concurrency conflict in multi-user environment (autocommit mode)

**SQL Execution Sequence:**
- **User A**: `SELECT balance FROM Account WHERE accountNumber = 1;` (Result: 1000)
- **User B**: `SELECT balance FROM Account WHERE accountNumber = 1;` (Result: 1000)
- **User B**: `UPDATE Account SET balance = 6000 WHERE accountNumber = 1;`
- **User B**: `SELECT balance FROM Account WHERE accountNumber = 1;` (Result: 6000)
- **User A**: `UPDATE Account SET balance = 1900 WHERE accountNumber = 1;`
- **User A**: `SELECT balance FROM Account WHERE accountNumber = 1;` (Result: 1900)

**Answers:**
1. No, I am not happy. The balance is 1900, but it should be 6900.
2. This is a **Lost Update** problem. User A overwrote User B's update because User A based their calculation on the initial balance (1000) and was unaware that User B had already updated it to 6000.

---

## Task 6: Explicit transactions in the default transaction isolation level

**SQL Execution Sequence:**
- **User A**: `BEGIN TRANSACTION; SELECT balance FROM Account WHERE accountNumber = 1;` (Result: 1000)
- **User B**: `BEGIN TRANSACTION; SELECT balance FROM Account WHERE accountNumber = 1;` (Result: 1000)
- **User B**: `UPDATE Account SET balance = 6000 WHERE accountNumber = 1;` (Succeeds, holds X-lock)
- **User A**: `UPDATE Account SET balance = 1900 WHERE accountNumber = 1;` (Blocks/Waits for User B)
- **User B**: `COMMIT; SELECT balance FROM Account WHERE accountNumber = 1;` (Result: 6000)
- **User A**: `COMMIT; SELECT balance FROM Account WHERE accountNumber = 1;` (Result: 1900)

**Answers:**
1. 1900.
2. The Lost Update still occurs. While explicit transactions and locking prevent simultaneous updates (User A had to wait for User B), User A still overwrites User B's committed change because they used stale data for their calculation.

---

## Task 7: Experiencing a deadlock

**SQL Execution Sequence:**
- **User A**: `BEGIN TRANSACTION; UPDATE Account SET balance = 6000 WHERE accountNumber = 1;` (Holds X-lock on Acc 1)
- **User B**: `BEGIN TRANSACTION; UPDATE Account SET balance = 2000 WHERE accountNumber = 2;` (Holds X-lock on Acc 2)
- **User A**: `UPDATE Account SET balance = 6000 WHERE accountNumber = 2;` (Waits for User B's lock on Acc 2)
- **User B**: `UPDATE Account SET balance = 2000 WHERE accountNumber = 1;` (Waits for User A's lock on Acc 1) -> **DEADLOCK DETECTED**

**Answers:**
1. Account 1: 6000, Account 2: 1000 (Assuming User B was the deadlock victim and rolled back).
2. Yes, it is consistent, but one transaction failed.
3. A deadlock occurred because User A held a lock on Account 1 and wanted a lock on Account 2, while User B held a lock on Account 2 and wanted a lock on Account 1. The DBMS detected this circular dependency and terminated one of the transactions (the "victim") to break the cycle.

---

## Task 8: Explicit transactions in the transaction isolation level REPEATABLE READ

**SQL Execution Sequence:**
- **User A**: `SET TRANSACTION ISOLATION LEVEL REPEATABLE READ; BEGIN TRANSACTION; SELECT balance FROM Account WHERE accountNumber = 1;` (Holds S-lock on Acc 1)
- **User B**: `SET TRANSACTION ISOLATION LEVEL REPEATABLE READ; BEGIN TRANSACTION; SELECT balance FROM Account WHERE accountNumber = 1;` (Holds S-lock on Acc 1)
- **User B**: `UPDATE Account SET balance = 6000 WHERE accountNumber = 1;` (Waits for User A's S-lock to be released)
- **User A**: `UPDATE Account SET balance = 1900 WHERE accountNumber = 1;` (Waits for User B's S-lock to be released) -> **DEADLOCK DETECTED**

**Answers:**
1. Account 1: 6000 (Assuming User A was the victim).
2. Yes, consistent.
3. In `REPEATABLE READ`, S-locks are held until the end of the transaction. Both users acquired S-locks on Account 1. When both attempted to upgrade to X-locks for the update, they blocked each other, resulting in a deadlock.

---

## Task 9: Transaction isolation levels REPEATABLE READ vs. READ COMMITTED

**SQL Execution Sequence:**
- **User A (RR)**: `BEGIN TRANSACTION; SELECT SUM(balance) FROM Account;` (Result: 2000. Holds S-locks on all rows)
- **User B (RC)**: `BEGIN TRANSACTION; UPDATE Account SET balance = balance + 500 WHERE accountNumber = 1;` (Blocks/Waits for User A's S-locks)
- **User A (RR)**: `SELECT SUM(balance) FROM Account;` (Result: 2000. Repeatable!)
- **User A (RR)**: `COMMIT;` (Locks released)
- **User B (RC)**: (Update now completes) `SELECT SUM(balance) FROM Account;` (Result: 2500)
- **User B (RC)**: `COMMIT;`

**Answer:**
1. Yes, User B had to wait for User A to commit.

---

## Task 10

**SQL Execution Sequence:**
- **User A (RC)**: `BEGIN TRANSACTION; SELECT SUM(balance) FROM Account;` (Result: 2000. S-locks released immediately after read)
- **User B (RC)**: `BEGIN TRANSACTION; UPDATE Account SET balance = balance + 500 WHERE accountNumber = 1;` (Succeeds immediately)
- **User A (RC)**: `SELECT SUM(balance) FROM Account;` (Result: 2500. Non-repeatable read!)
- **User A (RC)**: `COMMIT;`
- **User B (RC)**: `SELECT SUM(balance) FROM Account;` (Result: 2500)
- **User B (RC)**: `COMMIT;`

**Answers:**
1. No, neither had to wait.
2. In `READ COMMITTED`, shared locks (S-locks) are released as soon as the `SELECT` operation completes, rather than held until the end of the transaction. This allows User B to update the data while User A's transaction is still active.

---

## Task 11: Using the locking hint (UPDLOCK)

**SQL Execution Sequence:**
- **User A**: `SET TRANSACTION ISOLATION LEVEL REPEATABLE READ; BEGIN TRANSACTION; SELECT balance FROM Account (UPDLOCK) WHERE accountNumber = 1;` (Holds U-lock on Acc 1)
- **User B**: `SET TRANSACTION ISOLATION LEVEL REPEATABLE READ; BEGIN TRANSACTION; SELECT balance FROM Account (UPDLOCK) WHERE accountNumber = 1;` (Blocks/Waits for User A's U-lock)
- **User B**: `UPDATE Account SET balance = 6000 WHERE accountNumber = 1;` (Still waiting)
- **User A**: `UPDATE Account SET balance = 1900 WHERE accountNumber = 1;` (Succeeds, upgrades U-lock to X-lock)
- **User B**: `COMMIT;` (Still waiting for A)
- **User A**: `COMMIT;` (Locks released)
- **User B**: (Execution continues) `UPDATE...` (Succeeds)
- **User B**: `SELECT balance FROM Account WHERE accountNumber = 1;` (Result: 6000)
- **User A**: `SELECT balance FROM Account WHERE accountNumber = 1;` (Result: 6000)

**Answers:**
1. 6000.
2. Yes, consistent.
3. `UPDLOCK` forces a transaction to acquire an update lock during the initial read. Since only one U-lock can be held on a resource at a time, User B was blocked from reading the row until User A finished. This serialized the transactions and prevented the deadlock/lost update.

---

## Task 11 (Phantom Problem)

**SQL Execution Sequence:**
- **User A (RR)**: `BEGIN TRANSACTION; SELECT SUM(balance) FROM Account;` (Result: 2000)
- **User B (RR)**: `BEGIN TRANSACTION; SELECT SUM(balance) FROM Account;` (Result: 2000)
- **User B (RR)**: `INSERT INTO Account (accountNumber, balance) VALUES (4, 900); COMMIT;` (Succeeds)
- **User A (RR)**: `COMMIT; SELECT SUM(balance) FROM Account;` (Result: 2900)

**Answers:**
1. No, because User A thought the total was 2000 and would have allowed an insert, but User B also thought it was 2000 and inserted a row.
2. This is the **Phantom Problem**. `REPEATABLE READ` locks existing rows but does not lock the "gap" between rows or the end of the table, allowing new rows (phantoms) to be inserted that match the query criteria.

---

## Task 12: Preventing the "phantom problem"

**SQL Execution Sequence:**
- **User A (Ser)**: `BEGIN TRANSACTION; SELECT SUM(balance) FROM Account;` (Result: 2000. Holds range locks)
- **User B (Ser)**: `BEGIN TRANSACTION; SELECT SUM(balance) FROM Account;` (Result: 2000. Holds range locks)
- **User A (Ser)**: `INSERT INTO Account (accountNumber, balance) VALUES (3, 700);` (Succeeds)
- **User B (Ser)**: `INSERT INTO Account (accountNumber, balance) VALUES (4, 900);` (Blocks/Waits for User A's range lock)
- **User B (Ser)**: `COMMIT;` (Still waiting)
- **User A (Ser)**: `COMMIT; SELECT SUM(balance) FROM Account;` (Result: 2700)
- **User B (Ser)**: (Now executes) `INSERT...` (Succeeds)
- **User B (Ser)**: `COMMIT;`

**Answers:**
1. 3600 (2000 + 700 + 900).
2. No, because the total balance (3600) now exceeds the 3000 limit. While `SERIALIZABLE` prevents phantom reads within a transaction, the application logic here performed the check *before* the insert, and both transactions passed the check based on the initial state. To truly prevent this, the check and insert must be atomic or the total sum must be re-verified.

---

## Task 13: Important transaction concepts

**1. Why a DBMS should provide proper transaction management services?**
To ensure data integrity and consistency in a multi-user environment. Without it, concurrent access to the same data can lead to corrupted data, lost updates, and inconsistent states (e.g., money disappearing during a bank transfer).

**2. What are the ACID properties?**
- **Atomicity**: "All or nothing." Either the entire transaction succeeds or none of it is applied.
- **Consistency**: A transaction transforms the database from one valid state to another, maintaining all integrity constraints.
- **Isolation**: Concurrent transactions do not interfere with each other; they appear to run sequentially.
- **Durability**: Once a transaction is committed, its changes are permanent, even in the event of a system failure.
*Examples of failures:*
- *Atomicity failure*: A bank transfer subtracts money from account A but crashes before adding it to account B.
- *Isolation failure*: Two users book the last seat on a plane simultaneously because they both saw it as available (Lost Update).

**3. What is the purpose of transaction's isolation level?**
To balance the trade-off between **data consistency** and **system performance**. Higher isolation levels (like Serializable) provide maximum consistency but reduce concurrency (more blocking), while lower levels (like Read Committed) increase performance but allow certain anomalies.

**4. How do READ COMMITTED and REPEATABLE READ differ?**
- `READ COMMITTED` only holds S-locks for the duration of the read operation. If you read the same row twice in one transaction, another transaction could have changed it in between (**Non-repeatable Read**).
- `REPEATABLE READ` holds S-locks until the transaction completes. This guarantees that reading the same row twice will yield the same result, but it can lead to deadlocks more easily and does not prevent new rows from being inserted (**Phantom Read**).
