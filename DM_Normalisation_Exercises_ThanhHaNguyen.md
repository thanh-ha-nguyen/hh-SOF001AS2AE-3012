# DM / NORMALISATION Exercises

## EXERCISES

### 1. Consider the student data. Suppose that each student has a social security number. Which of the following dependencies are true?

a) date of birth → student number: **False**

b) student number → date of birth: **True**

c) student number → height: **True**

d) height → student number: **False**

e) social security number → student number: **True**

f) student number → social security number: **True**

### 2. Which of the following functional dependencies do definitely not hold over the table below?
The functional dependencies that definitely do not hold are:

c) { B, C } → A (because {2,3} maps to both A=1 and A=4)

d) B → A (because B=2 maps to both A=1 and A=4)

### 3. Which of the following functional dependencies do definitely not hold over the table below?
The functional dependencies that definitely do not hold are:

a) C → B (because C=5 maps to both B=3 and B=2)

d) A → D (because A=1 maps to both D=5 and D=7)

### 4. Determine candidate keys for the following relations:

**a) R1 (X, Y, Z)**

*   Functional Dependencies: Z → X, Z → Y
*   Candidate Key: {Z}

**b) R2 (A, B, C, D)**

*   Functional Dependencies: C → A, D → B, A → D
*   Candidate Key: {C}

**c) R3 (A, B, C, D)**

*   Functional Dependencies: C → D, C → A, B → C
*   Candidate Key: {B}

**c) R4 (A, B, C)**

*   Functional Dependencies: B → A, C → B, B → C, C → A
*   Candidate Keys: {B}, {C}

### 5. What is the normal form for each of the relations below? Give arguments!

**a) CREW_MEMBER (date, ssn)**

*   Normal Form: **BCNF**
*   Reason: As `ssn` is likely the primary key, there are no non-key attributes, thus no partial or transitive dependencies exist.

**b) PROJECT_MEMBER (projectno, empno, empRoleInTheProject, gender)**

*   Normal Form: **1NF**
*   Reason: If the primary key is {projectno, empno}, then `gender` (non-key attribute) is partially dependent on `empno` (part of the primary key), violating 2NF.

**c) COUNTRY (continent, countryname, population)**

*   Normal Form: **BCNF**
*   Reason: Assuming `countryname` is the primary key, all other attributes (`continent`, `population`) are fully functionally dependent on it, and there are no non-key determinants.

**d) DEPARTMENT (deptno, deptname, companycode, companyname)**

*   Normal Form: **2NF**
*   Reason: Assuming `deptno` is the primary key, `companyname` is transitively dependent on `deptno` via `companycode` (deptno → companycode → companyname), violating 3NF.

**e) TEXTBOOK (ISBN, bookname, chapternumber, chaptername, publisher)**

*   Normal Form: **1NF**
*   Reason: If the primary key is {ISBN, chapternumber}, `bookname` and `publisher` are partially dependent on `ISBN` (part of the primary key), violating 2NF.

**f) EMPLOYEE (empno, surname, firstname, PHONE(phonenumber, phonetype))**

*   Normal Form: **2NF**
*   Reason: After flattening the `PHONE` attribute, if `empno` is the primary key, then `phonetype` is transitively dependent on `empno` via `phonenumber` (empno → phonenumber → phonetype), violating 3NF.

**g) R (A, B, C, D)**

*   Functional Dependencies: { A, B } → D, { A, C } → D, B → C, C → B
*   Candidate Keys: {A, B}, {A, C}
*   Normal Form: **3NF**
*   Reason: The dependencies B → C and C → B exist. Both B and C are prime attributes (part of candidate keys {A,B} and {A,C}). Since the determinants (B and C) are prime attributes, it satisfies 3NF. However, neither B nor C is a superkey, so it is not in BCNF.

### 7. Based on the dependency diagram below, create relations that are in BCNF.

Original Functional Dependencies:
*   { medicinename, patientId, date } → refillsAllowed
*   { medicinename, patientId, date } → dosage
*   { medicinename, patientId, date } → shelflife
*   patientId → patientName
*   medicinename → shelflife

BCNF Relations:

<pre>
PATIENT (<u>patientId</u>, patientName)
MEDICINE (<u>medicinename</u>, shelflife)
PRESCRIPTION (<u>medicinename</u>, <u>patientId</u>, <u>date</u>, refillsAllowed, dosage)
    FOREIGN KEY (patientId) REFERENCES PATIENT(patientId)
    FOREIGN KEY (medicinename) REFERENCES PRESCRIPTION(medicinename)
</pre>

### 8. Normalise the relations below to BCNF.

**a) PLAYER (playerno, surname, firstname, teamnumber, teamname)**

*   Primary Key: {playerno}
*   Functional Dependencies: playerno → surname, firstname, teamnumber; teamnumber → teamname
*   Current Normal Form: **2NF** (Violates 3NF due to transitive dependency `playerno` → `teamnumber` → `teamname`)
*   BCNF Decomposition:

<pre>
TEAM (<u>teamnumber</u>, teamname)
PLAYER (<u>playerno</u>, surname, firstname, teamnumber)
    FOREIGN KEY (teamnumber) REFERENCES TEAM(teamnumber)
</pre>

**b) BOOKING (ISBN, bookname, patronid, surname, firstname, bookingdate, bookingtime)**

*   Primary Key: {ISBN, patronid, bookingdate, bookingtime}
*   Functional Dependencies: ISBN → bookname; patronid → surname, firstname
*   Current Normal Form: **1NF** (Violates 2NF due to partial dependencies: ISBN → bookname and patronid → surname, firstname)
*   BCNF Decomposition:

<pre>
BOOK (<u>ISBN</u>, bookname)
PATRON (<u>patronid</u>, surname, firstname)
BOOKING_EVENT (<u>ISBN</u>, <u>patronid</u>, <u>bookingdate</u>, <u>bookingtime</u>)
    FOREIGN KEY (ISBN) REFERENCES BOOK(ISBN)
    FOREIGN KEY (patronid) REFERENCES PATRON(patronid)
</pre>

**c) ORDER (orderno, productno, productname, quantity, clientno, deliveryaddress, clientaddress)**

*   Primary Key: {orderno, productno}
*   Functional Dependencies: productno → productname; orderno → clientno, deliveryaddress, clientaddress; clientno → clientaddress
*   Current Normal Form: **1NF** (Violates 2NF due to partial dependency productno → productname; also violates 3NF due to transitive dependency orderno → clientno → clientaddress)
*   BCNF Decomposition:

<pre>
PRODUCT (<u>productno</u>, productname)
CLIENT (<u>clientno</u>, clientaddress)
ORDER (<u>orderno</u>, clientno, deliveryaddress)
    FOREIGN KEY (clientno) REFERENCES CLIENT(clientno)
ORDER_ITEM (<u>orderno</u>, <u>productno</u>, quantity)
    FOREIGN KEY (orderno) REFERENCES ORDER(orderno)
    FOREIGN KEY (productno) REFERENCES PRODUCT(productno)
</pre>

## Recapping normal form rules

### 9. Suppose the following relation and functional dependencies: XYZ (a, b, c, d, e)
*   Functional Dependencies: a → b, c, d, e; b → d

**a) Determine the primary key**

*   Primary Key: {a}

**b) Explain why the relation XYZ is not in 3NF.**

*   Argument: The non-key attribute 'd' is transitively dependent on the primary key 'a' via 'b' (a → b and b → d), and 'b' is not a superkey, nor is 'd' a prime attribute. This violates 3NF.

**c) Normalise the relation XYZ to BCNF.**

*   BCNF Decomposition:

<pre>
BD (<u>b</u>, d)
ABC_E (<u>a</u>, b, c, e)
    FOREIGN KEY (b) REFERENCES BD(b)
</pre>

### 10. Suppose the following relation and functional dependencies: XYZ (a, b, c, d)
*   Functional Dependencies: a → c; {a, d} → b, c

**a) Determine the primary key**

*   Primary Key: {a, d}

**b) Explain why the relation is not in 2NF.**

*   Argument: The non-key attribute 'c' is partially dependent on 'a', which is a proper subset of the composite primary key {a, d}. This violates 2NF.
**c) Normalise the relation to BCNF.**
*   BCNF Decomposition:

<pre>
AC (<u>a</u>, c)
ABD (<u>a</u>, <u>d</u>, b)
    FOREIGN KEY (a) REFERENCES AC(a)
</pre>

## OPTIONAL MORE ADVANCED TASKS

### T1. Consider the relation schema R(A, B, C), which has the FD B → C. If A is a candidate key for R, is it possible for R to be in BCNF? If not, explain why not.
No, it is not possible for R to be in BCNF. For a relation to be in BCNF, every determinant of a non-trivial functional dependency must be a superkey. In the given FD B → C, B is the determinant. Since {A} is the candidate key, B is not a superkey (as B does not determine A). Therefore, R is not in BCNF.
