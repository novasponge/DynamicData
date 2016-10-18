CREATE TABLE tasks (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description VARCHAR(255) NOT NULL,
  list_id INTEGER,

  FOREIGN KEY(list_id) REFERENCES list(id)
);

CREATE TABLE lists (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  author_id INTEGER,

  FOREIGN KEY(author_id) REFERENCES user(id)
);

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  username VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL
);

INSERT INTO
tasks (id, name, description, list_id)
VALUES
(1, "Shopping this weekend", "Buy Apple, Avocado, Ice cream", 1),
(2, "Call Aaron", "Arrang dinner with Aaron", 2),
(3, "Go pick Mike", "Mike needs to see doctor tomorrow", 3),
(4, "Annual health monitor", "I need to pay attention to my blood pressure", 3),
(5, "Walk Dog", ":)", NULL);

INSERT INTO
  lists (id, name, author_id)
VALUES
  (1, "Shopping", 1),
  (2, "Aaron", 2),
  (3, "Mike", 1),
  (4, "Doctor appointment", NULL);

INSERT INTO
users (id, username, email)
VALUES
(1, "Aaron Grau", "Aroan@aol.com"), (2, "Harles Richey", "Harles@gmail.com");
