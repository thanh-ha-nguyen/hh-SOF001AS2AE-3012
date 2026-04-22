# Database Normalisation Orientation Exercises

## TASK 1

### Question 1: Mention at least one consistency problem that can arise after we UPDATE a value on one of the rows.
*   If the `coursename` for `coursecode` 10 is updated in one row (e.g., from 'Java' to 'Advanced Java'), but not in another row with the same `coursecode`, it leads to an inconsistency where the same `coursecode` has different `coursename` values. 
*   Similarly, if a teacher's `office` or `officesize` is updated in one row but not all rows where that teacher appears, it results in inconsistent office information for that teacher.

### Question 2: Mention one database content problem that can arise after we DELETE a row from the table.
*   Deleting the last row associated with a `coursecode` (e.g., `coursecode` 30, `HTML & CSS`) would result in losing all information about that course (`coursename`) even if other teachers might teach it or it is a valid course. 
*   Similarly, deleting the last row for a `teacherno` would remove all information about that teacher's `office` and `officesize`.

### Question 3: How about INSERTing facts about a new teacher? Any potential problems there?
*   If a new teacher is hired but not yet assigned to a course, their information (e.g., `teacherno`, `teacher`, `office`, `officesize`) cannot be inserted into this table without providing `coursecode` and `coursename` values, which might be non-existent or null. This violates the requirement that teachers can exist without teaching a course.

## TASK 2

### Question: Fix the design and show the structure as one or more relation schemas. Underline primary keys and include foreign key definitions.

<pre>
COURSES (<u>coursecode</u>, coursename)
TEACHERS (<u>teacherno</u>, teacher, office, officesize)
TEACHING_ASSIGNMENTS (<u>coursecode</u>, <u>teacherno</u>)
    FOREIGN KEY (coursecode) REFERENCES COURSES(coursecode)
    FOREIGN KEY (teacherno) REFERENCES TEACHERS(teacherno)
</pre>