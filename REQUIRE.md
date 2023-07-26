# REQUIREMENTS

## Music Store

An entrepreneur has contacted your team seeking a technology partner for his new business idea. Fighting against the discography monopolies of the world, the venture consists of an online store for independent artists. The goal is to start modeling the first MVP for albums©. These are the business requirements:

- The store will sell music albums to their customers
- Each album has a name and a price (stored in cents). An album has many songs and belongs to an artist (only to one artist). A valid album always has a name and a price greater than zero.
- A song has a name and duration (in seconds). A song belongs only to one album. A song should always have a name and its duration cannot be zero or less.
- An artist has a name, nationality, birth_date, and death_date. Only the name is mandatory. If we store the birth_date, it cannot be in the future and if we store a death_date two conditions should be met: the birth_date exists and the death_date is after the birth_date. An artist could have many albums.
- The customer can place orders in the store. Each order has a date and a total (the sum of the product of the quantity and price of each album included on the order). An order could include many albums and an album could appear y many orders. We need to store how many copies of an album are purchased in each order. This quantity should be positive. The order total cannot be negative and the date cannot be in the future.
- A customer has a username, email, password, name, and an active flag (could be true or false). The email should have an email format, the username is required, the password should have a length of at least 6 characters and includes at least one number. By default, a customer is active on creation. Both username and email should be unique.

### Task 1: Create an ERD

Following all the requirements, create an Entity Relationship Diagram with the tables, fields, data types (Rails data types), and relationships. Include a file with your ERD on your solution (JPG, PNG, PDF)

### Task 2: Setup the rails app

    rails new . -d postgresql --skip-test

### Task 3: Create the models and database schema

Following your ERD, create all the models and migrations required.

### Task 4: Create the validations

On each model, add all the required validations.

### Task 5: Create migrations

    Create a migration to add the column biography of type string to the artist's table.
    Create a migration to add a duration (integer) to the table albums.
    Create a migration to add a unique index to the columns username and email of the customer's table.
    Create a migration to change the data type of the column biography of artists table from string to text.

All migrations should be reversible.

### Task 6: Create seed data

With all the models and validations set in place, create the following seed data:

    Create 10 artists.
    Create between 2 to 6 albums for each artist.
    Create between 4 and 10 songs for each album.
    Create 15 customers.
    Create between 1 and 5 orders for each customer.
    Each order should include between 1 and 4 albums. And the quantity of each album in each order should be between 1 and 3.

💡 The album duration should be the sum of the duration of all their songs. The order total should be the sum of the product of the quantity and price of each album included on the order.
