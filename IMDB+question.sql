USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT 
    TABLE_NAME, TABLE_ROWS       -- The name of the tables,rows.
FROM
    INFORMATION_SCHEMA.TABLES    -- INFORMATION_SCHEMA provides access to database metadata.
WHERE
    TABLE_SCHEMA = 'imdb';       -- The name of the schema to which the table belongs.




-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT count(*) FROM Movie WHERE ID IS NULL;
SELECT count(*) FROM Movie WHERE title IS NULL;
SELECT count(*) FROM Movie WHERE year IS NULL;
SELECT count(*) FROM Movie WHERE date_published IS NULL;
SELECT count(*) FROM Movie WHERE duration IS NULL;
SELECT count(*) FROM Movie WHERE country IS NULL;               -- This COUNTRY column has NULL Value
SELECT count(*) FROM Movie WHERE worlwide_gross_income IS NULL; -- This WORLWIDE_GROSS_INCOME column has NULL Value
SELECT count(*) FROM Movie WHERE languages IS NULL;             -- This LANGUAGES column has NULL Value
SELECT count(*) FROM Movie WHERE production_company IS NULL;    -- This PRODUCTION_COMPANY column has NULL Value

	

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    year AS Year, COUNT(id) AS number_of_movies        
FROM                                       -- Year wise movie count
    movie
GROUP BY year;

SELECT 
    MONTH(date_published) AS month_num,
    COUNT(id) AS number_of_movies 
FROM                                      -- Month wise movie count
    movie
GROUP BY month_num
ORDER BY month_num;






/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT 
    COUNT(id) AS Number_of_movies_USA_or_India_2019
FROM
    movie
WHERE
    (Country LIKE '%USA%' OR Country LIKE '%India%') AND year = 2019;




/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT
    (genre)
FROM
    genre;








/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT 
    g.genre, COUNT(m.id) AS Number_of_movies
FROM
    movie m
        INNER JOIN                            -- INNER JOIN is used here to join Table MOVIE and GENRE
    genre g ON m.id = g.movie_id              -- So that  movies counting can be done genre wise.
GROUP BY g.genre
ORDER BY COUNT(m.id) DESC LIMIT 1;            -- I have sorted by Movies count and printed just the max count genre thus used limit 1.







/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

-- Method 1 - By CTE method

WITH one_genre_movie AS                              -- Creating a CTE in which genre Count is stored group by the movie id
(
SELECT 
   movie_id, COUNT(genre) AS genre_count
FROM
   genre
GROUP BY movie_id
)
SELECT 
    SUM(genre_count) AS Number_of_one_genre_movie
FROM
    one_genre_movie
WHERE
    genre_count = 1;                                --  Check for genre count equal to 1



-- Method 2 - By VIEW method

CREATE VIEW one_genre_movie AS
    (SELECT 
        movie_id
    FROM
        genre
    GROUP BY movie_id
    HAVING COUNT(genre) = 1);
SELECT 
    COUNT(movie_id)
FROM
    one_genre_movie;






/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    g.genre, ROUND(AVG(m.duration)) AS avg_duration    -- round function is used just to round the average of duration.
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
GROUP BY g.genre
ORDER BY avg_duration DESC;







/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT 
* 
FROM 
(
	SELECT 
		g.genre,count(m.id) AS movie_count,
		RANK() OVER( ORDER BY count(m.id) DESC ) AS genre_rank     -- Rank function is used to find the rank of genre based on the 
	FROM                                                           -- count of the movie id.
		movie m
			INNER JOIN
		genre g ON m.id = g.movie_id
	GROUP BY g.genre
) AS x
WHERE genre = "Thriller";                                          -- Check is provided as per the demand of the Question.








/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
	ROUND(MIN(avg_rating)) AS min_avg_rating,           -- Used max and min functions to find the maximun and minimum in the respective columns.
    ROUND(MAX(avg_rating)) AS max_avg_rating,           -- Round we have used just to match the O/P
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM
    ratings;




    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT m.title,
		r.avg_rating,
		Rank()
			OVER(ORDER BY r.avg_rating DESC) AS movie_rank
        FROM   movie m
               INNER JOIN ratings r
			   ON m.id = r.movie_id
        LIMIT 10;                                              -- I am using limit in order to get only top 10 movies.





/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT 
    median_rating, COUNT(movie_id) AS movie_count
FROM
    ratings
GROUP BY median_rating
ORDER BY median_rating;







/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT *
FROM   (SELECT production_company,
               COUNT(id) AS movie_count,
               Rank()
                 OVER(
                   ORDER BY COUNT(id) DESC) AS prod_company_rank
        FROM   movie m
               INNER JOIN ratings r
                       ON m.id = r.movie_id
        WHERE  r.avg_rating > 8
               AND m.production_company IS NOT NULL  -- Just omitting the Null values in production_company
        GROUP  BY production_company
        ) AS x                                       -- x here is used just as an alias to use prod_company_rank in where clause
WHERE  x.prod_company_rank = 1;                      -- Just printing the top rank production_company





-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    genre, COUNT(g.movie_id) AS movie_count
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
        INNER JOIN
    ratings r USING (movie_id)
WHERE
    year = 2017
        AND MONTH(date_published) = 3           -- Checks provided as per question for each genre for March 2017
        AND Country LIKE '%USA%'                -- Just checking for USA but it may have more than one country in it.
        AND total_votes > 1000
GROUP BY genre;




-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
     m.title,avg_rating,genre
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
        INNER JOIN
    ratings r USING (movie_id)
WHERE
    m.title LIKE 'The%' AND avg_rating > 8     -- Checks provided as per question for each genre
    ORDER BY g.genre;                        -- just doing for clear readability




-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
     count(m.id) as Number_of_movies
FROM
    movie m
        INNER JOIN ratings r 
       on m.id = r.movie_id
WHERE
     median_rating = 8 
     and date_published between "2018-04-01" and  "2019-04-01";



-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

-- Method 1
WITH Country_compare
     AS (SELECT m.Country,
                SUM(total_votes) AS Total_Votes
         FROM   movie m
                INNER JOIN ratings r
                        ON m.id = r.movie_id
         WHERE  m.Country LIKE "%Germany%"
         UNION ALL
         SELECT m.Country,
                SUM(total_votes) AS Total_Votes
         FROM   movie m
                INNER JOIN ratings r
                        ON m.id = r.movie_id
         WHERE  m.Country LIKE "%Italy%")
SELECT *
FROM   Country_compare;


-- In the above query I have assumed that a movie is said to be either German or Italian if and only if it belongs to 
-- Germany, Italy respectively.
-- Conclusion
-- Yes ,German movies get more votes than Italian movies.

-- Method 2
WITH langauge_compare
     AS (SELECT m.languages,
                SUM(total_votes) AS Total_Votes
         FROM   movie m
                INNER JOIN ratings r
                        ON m.id = r.movie_id
         WHERE  m.languages LIKE "%german%"
         UNION ALL
         SELECT m.languages,
                SUM(total_votes) AS Total_Votes
         FROM   movie m
                INNER JOIN ratings r
                        ON m.id = r.movie_id
         WHERE  m.languages LIKE "%italian%")
SELECT *
FROM   langauge_compare; 

-- In the above query I have assumed that a movie is said to be either German or Ialian if movie is in  german and italian langauge respectively.
-- Conclusion
-- Yes ,German movies get more votes than Italian movies.

-- Final Conclusion
-- Going by both the above logic German movies get more vote than the Italian movie.




-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

-- Method 1 - In this we have taken help of when clause to count NULL value(s) if any.

SELECT 
    SUM(CASE
        WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
    SUM(CASE
        WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
    SUM(CASE
        WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
    SUM(CASE
        WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM
    names;

-- Method 2 - We are using count function to check Null value(s) by calculating the difference between the COUNT(*)and COUNT(Column_name)

SELECT COUNT(*)-COUNT(name) AS name_nulls,                         
		COUNT(*)-COUNT(height) AS height_nulls, 
		COUNT(*)-COUNT(date_of_birth) AS date_of_birth_nulls, 
		COUNT(*)-COUNT(known_for_movies) AS known_for_movies_nulls
FROM names;


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_3_genre AS                                      --  First let's seprate all the top 3 genre in a CTE
(
           SELECT     g.genre ,
                      COUNT( g.movie_id ) AS movie_count
           FROM       genre g
           INNER JOIN ratings r
           ON         g.movie_id = r.movie_id
           WHERE      avg_rating>8
           GROUP BY   g.genre
           ORDER BY   movie_count DESC limit 3 ) , 
top_3_director AS                                     --  In this CTE we are filtering directors information based on the above CTE(top_3_genre)
(
           SELECT     
                      n.name AS director_name ,
                      COUNT( dm.movie_id ) AS movie_count,
                      Rank() OVER(ORDER BY COUNT(dm.movie_id) DESC) AS director_rank
           FROM       names n
           INNER JOIN director_mapping dm
           ON         dm.name_id = n.id
           INNER JOIN ratings r
           ON         r.movie_id = dm.movie_id
           INNER JOIN genre g
           ON         g.movie_id = dm.movie_id,
                      top_3_genre
           WHERE      g.genre IN ( top_3_genre.genre )
           AND        r.avg_rating > 8
           GROUP BY   n.NAME
           ORDER BY   movie_count DESC )
SELECT director_name ,
       movie_count
FROM   top_3_director
WHERE  director_rank <= 3 LIMIT 3;          -- Limit is provided to get just 3 directors name as per the question.




/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    n.name AS actor_name, COUNT(rm.movie_id) AS movie_count
FROM
    names n
        INNER JOIN
    role_mapping rm ON n.id = rm.name_id
        INNER JOIN
    ratings r ON r.movie_id = rm.movie_id
WHERE
    rm.category = 'actor'
        AND r.median_rating >= 8
GROUP BY rm.name_id
ORDER BY movie_count DESC
LIMIT 2;





/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT *
FROM   (SELECT production_company,
               SUM(total_votes) AS vote_count,
               Rank()
                 OVER( ORDER BY SUM(total_votes) DESC ) AS prod_comp_rank
        FROM   movie m
               INNER JOIN ratings r
                       ON m.id = r.movie_id
        GROUP  BY production_company
        ) AS x                       -- x here is used just as an alias to use prod_comp_rank in where clause
WHERE  x.prod_comp_rank <= 3; 


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT 
       n.name AS actor_name,
       SUM(r.total_votes) AS total_votes,
       COUNT(m.id) AS movie_count,
       ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS actor_avg_rating,   -- weighted average based on votes is used
       Rank()
         OVER ( ORDER BY ROUND(SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes), 2) DESC) AS actor_rank 
FROM   names n
       INNER JOIN role_mapping rm
               ON n.id = rm.name_id
       INNER JOIN movie m
               ON m.id = rm.movie_id
       INNER JOIN ratings r
               ON r.movie_id = m.id
WHERE  m.country LIKE "%India%"          --  Check for India
       AND rm.category = "actor"         --  Check for actor only
GROUP  BY n.name
HAVING movie_count >= 5;                 --  Check for Actors with atleast 5 movies



-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT 
       n.name AS actress_name,
       r.total_votes AS total_votes,
       COUNT(m.id) AS movie_count,
       ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS actress_avg_rating,     -- weighted average based on votes is used
       Rank()
         OVER ( ORDER BY(ROUND(SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes), 2)) DESC) AS actress_rank
FROM   names n
       INNER JOIN role_mapping rm
               ON n.id = rm.name_id
       INNER JOIN movie m
               ON m.id = rm.movie_id
       INNER JOIN ratings r
               ON r.movie_id = m.id
WHERE  m.languages like "%Hindi%"            --  Check for Hindi
       AND m.country like "%India%"          --  Check for India
       AND rm.category = "actress"           --  Check for actress only
GROUP  BY n.name
HAVING movie_count >= 3                      --  Check for actress with atleast 3 movies
LIMIT 5; 





/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT 
    m.Title,        -- We have not shown avg_rating as it is not clearly mentioned in question if we should show that column or not.
    CASE
        WHEN r.avg_rating > 8 THEN 'Superhit movies'
        WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
        WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
        ELSE 'Flop movies'
    END AS Thriller_Category
FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
        INNER JOIN
    genre g ON g.movie_id = r.movie_id
WHERE
    g.genre = 'Thriller';




/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT g.genre,
       ROUND(AVG(m.duration)) AS avg_duration,
       ROUND(SUM(AVG(m.duration))
       
       -- Calculating the running total average
               over (ORDER BY g.genre RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 1) AS running_total_duration,  
               
		-- Calculating the moving average duration
       ROUND(AVG(AVG(m.duration))
               over( ORDER BY g.genre RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS moving_avg_duration
FROM   genre g
       inner join movie m
               ON g.movie_id = m.id
GROUP  BY g.genre;




-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

-- Assumption
-- We are treating the worlwide_gross_income column as as a fixed curreny and assuming  "$" and "INR" as the same reference currency

CREATE VIEW replace_string AS -- I have Created a View for replacing the $ and INR from the worlwide_gross_income column.
SELECT *,
       CASE
              WHEN worlwide_gross_income LIKE '%INR%' THEN Cast(Replace(worlwide_gross_income, 'INR', '') AS DECIMAL(30))
              WHEN worlwide_gross_income LIKE '%$%' THEN Cast(Replace(worlwide_gross_income, '$', '') AS     DECIMAL(30))
              ELSE NULL
       END AS new_worlwide_gross_income
FROM   movie;

WITH top_3_genre AS 
-- I have used CTE to filter all the top 3 Genre and will use this CTE in the other CTE to get the required O/P
(
         SELECT   genre
         FROM     genre
         GROUP BY genre
         ORDER BY COUNT(movie_id) DESC LIMIT 3 ), 
year_wise_5_movie AS
(
		 SELECT   g.genre ,
				  m.year ,
				  m.title                                                                          AS movie_name ,
				  m.new_worlwide_gross_income                                                      AS worlwide_gross_income,
				  DENSE_RANK() OVER(PARTITION BY m.year ORDER BY m.new_worlwide_gross_income DESC) AS movie_rank
		 FROM       replace_string m
		 INNER JOIN genre g
		 ON         m.id = g.movie_id,
					top_3_genre
		 WHERE      g.genre IN (top_3_genre.genre) -- Top_3_Genre CTE's genre will be passed to Year_Wise_5_Movie CTE
)
SELECT DISTINCT *
FROM            year_wise_5_movie
WHERE           movie_rank <=5;





-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT *
FROM   (SELECT m.production_company,
               COUNT(m.id) AS movie_count,
               Rank()
                 over(
                   ORDER BY COUNT(m.id) DESC) AS prod_comp_rank
        FROM   movie m
               inner join ratings r
                       ON m.id = r.movie_id
        WHERE  r.median_rating >= 8
               AND m.production_company IS NOT NULL  -- Just omitting the Null values in production_company
               AND Position("," IN m.languages) > 0  -- Check for Multilanguage movies.
        GROUP  BY m.production_company
        ) AS x                                       -- x here is used just as an alias to use prod_comp_rank in where clause
WHERE  x.prod_comp_rank <= 2;                        -- Just printing the top 2 production_company



-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT     
           n.name                                       AS actress_name ,
           SUM(r.total_votes)                           AS total_votes ,
           COUNT(r.movie_id)                            AS movie_count ,
           ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS actress_avg_rating , -- Calculating the weighted actress_avg_rating 
           RANK() OVER(ORDER BY COUNT(r.movie_id) DESC) AS actress_rank
FROM       names n
INNER JOIN role_mapping rm
ON         n.id = rm.name_id
INNER JOIN ratings r
ON         rm.movie_id = r.movie_id
INNER JOIN genre g
ON         r.movie_id = g.movie_id
WHERE      avg_rating >8 
AND        g.genre = "Drama"
AND        rm.category = "actress"
GROUP BY   actress_name
ORDER BY   movie_count DESC LIMIT 3; -- Limit is used to get top 3 actresses only as per question



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

CREATE VIEW next_movie_day AS                -- Creating a view to store next day value by the lead ().
  SELECT
       n.name , n.id , date_published,
       LEAD(date_published,1) OVER(PARTITION BY n.id ORDER BY m.date_published) AS next_day
  FROM movie m
      INNER JOIN director_mapping dm 
      ON m.id = dm.movie_id 
      INNER JOIN names n 
      ON dm.name_id = n.id;

CREATE VIEW inter_movie_day AS              -- Creating a view to get the difference between the next day and the date_published.
    SELECT 
        *,
        DATEDIFF(next_day, date_published) AS diff,
        AVG(DATEDIFF(next_day, date_published)) AS avg_inter_movie_days
    FROM
        next_movie_day
    GROUP BY id;


SELECT 
    n.id AS director_id,
    n.name AS director_name,
    COUNT(r.movie_id) AS number_of_movies,
    ROUND(i.avg_inter_movie_days) AS avg_inter_movie_days,    -- With the help of the above two View avg_inter_movie_days is calculated
    ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes),2) AS avg_rating,  -- Calculating the weighted avg_rating 
    SUM(r.total_votes) AS total_votes,
    MIN(r.avg_rating) AS min_rating,
    MAX(r.avg_rating) AS max_rating,
    SUM(m.duration) AS total_duration
FROM
    inter_movie_day i                     -- Joining the View inter_movie_day with Table name
	INNER JOIN names n
	ON n.id = i.id
	INNER JOIN director_mapping dm 
    ON n.id = dm.name_id
	INNER JOIN movie m 
    ON dm.movie_id = m.id
	INNER JOIN ratings r 
    ON m.id = r.movie_id
GROUP BY director_name
ORDER BY number_of_movies DESC
LIMIT 9;                                     -- Limit 9 is given in order  to show top 9 directors








