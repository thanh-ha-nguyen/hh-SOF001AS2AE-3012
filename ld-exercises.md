# Logical Database Design Exercises

## Task 1: Warm-up

![Task 1](./images/ld-task-1.png)

<pre>
Machine (<ins>serialnumber</ins>, model)
Factory (<ins>factoryname</ins>, email, serialnumber)
    FK (serialnumber) REFERENCES Machine (serialnumber)
</pre>

## Task 2: Warm-up drills with simple diagrams

a.  ![Task 2a](./images/ld-task-2-a.png)

<pre>
Company (<ins>companycode</ins>, name, email)
Truck (<ins>platenumber</ins>, model, capacity, companycode)
    FK (companycode) REFERENCES Company (companycode)
</pre>

b.  ![Task 2b](./images/ld-task-2-b.png)

<pre>
Hotel (<ins>hotelnumber</ins>, name)
Room (<ins>hotelnumber</ins>, <ins>roomnumber</ins>, roomtype)
    FK (hotelnumber) REFERENCES Hotel (hotelnumber)
</pre>

c.  ![Task 2c](./images/ld-task-2-c.png)

<pre>
Project (<ins>projectno</ins>, name, startdate)
Employee (<ins>empno</ins>, familyname, givenname)
WorksIn (<ins>projectno</ins>, <ins>empno</ins>)
    FK (projectno) REFERENCES Project (projectno)
    FK (empno) REFERENCES Employee (empno)
</pre>

d.  ![Task 2d](./images/ld-task-2-d.png)

<pre>
Employee (<ins>empno</ins>, familyname, givenname)
EmployeeEmail (<ins>empno</ins>, <ins>email</ins>)
    FK (empno) REFERENCES Employee (empno)
</pre>

e.  ![Task 2e](./images/ld-task-2-e.png)

<pre>
Employee (<ins>empno</ins>, birthdate, familyname, givenname, age, manager_empno)
    FK (manager_empno) REFERENCES Employee (empno)
</pre>

## Task 3: Translating ER diagrams to relation schemas

a.  ![Task 3a](./images/ld-task-3-a.png)

<pre>
A (<ins>aa</ins>, bb)
B (<ins>cc</ins>, dd, aa)
    FK (aa) REFERENCES A (aa)
</pre>

b.  ![Task 3b](./images/ld-task-3-b.png)

<pre>
X (<ins>aa</ins>, bb)
Y (<ins>cc</ins>, dd)
XY (<ins>aa</ins>, <ins>cc</ins>)
    FK (aa) REFERENCES X (aa)
    FK (cc) REFERENCES Y (cc)
</pre>

c.  ![Task 3c](./images/ld-task-3-c.png)

<pre>
O (<ins>aa</ins>, bb, cc)
    FK (cc) REFERENCES P (cc)
P (<ins>cc</ins>, dd)
</pre>

## Task 4: Boat crews

![Task 4](./images/ld-task-4.png)

<pre>
Sailor (<ins>snn</ins>, givenname, familyname, phone)
Crew (<ins>sailingdate</ins>, starttime, description, captain_snn, engineer_snn)
    FK (captain_snn) REFERENCES Sailor (snn)
    FK (engineer_snn) REFERENCES Sailor (snn)
CrewMember (<ins>sailingdate</ins>, <ins>snn</ins>)
    FK (sailingdate) REFERENCES Crew (sailingdate)
    FK (snn) REFERENCES Sailor (snn)
</pre>

## Task 5: University

![Task 5](./images/ld-task-5.png)

<pre>
DegreeProgram (<ins>program_code</ins>, program_name)
Course (<ins>course_code</ins>, course_name, credits, program_code)
    FK (program_code) REFERENCES DegreeProgram (program_code)
CourseOffering (<ins>course_code</ins>, <ins>offering_number</ins>, start_date)
    FK (course_code) REFERENCES Course (course_code)
Teacher (<ins>employee_number</ins>, given_name, family_name)
Student (<ins>student_number</ins>, given_name, family_name, advisor_emp_no, thesis_advisor_emp_no)
    FK (advisor_emp_no) REFERENCES Teacher (employee_number)
    FK (thesis_advisor_emp_no) REFERENCES Teacher (employee_number)
Enrolls (<ins>student_number</ins>, <ins>course_code</ins>, <ins>offering_number</ins>)
    FK (student_number) REFERENCES Student (student_number)
    FK (course_code, offering_number) REFERENCES CourseOffering (course_code, offering_number)
Teaches (<ins>employee_number</ins>, <ins>course_code</ins>, <ins>offering_number</ins>)
    FK (employee_number) REFERENCES Teacher (employee_number)
    FK (course_code, offering_number) REFERENCES CourseOffering (course_code, offering_number)
</pre>