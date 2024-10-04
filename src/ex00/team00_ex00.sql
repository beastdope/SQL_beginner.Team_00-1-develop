CREATE TABLE ways
(
    id SERIAL PRIMARY KEY,
    point1 CHARACTER,
    point2 CHARACTER,
    cost INTEGER
);
INSERT INTO ways (point1, point2, cost)
VALUES ('a', 'b', 10),
       ('a', 'c', 15),
       ('a', 'd', 20),
       ('b', 'a', 10),
       ('b', 'c', 35),
       ('b', 'd', 25),
       ('c', 'a', 15),
       ('c', 'b', 35),
       ('c', 'd', 30),
       ('d', 'a', 20),
       ('d', 'b', 25),
       ('d', 'c', 30);

WITH RECURSIVE cte_ways (point1, point2, tour, cost) AS (
    SELECT w1.point1, w1.point2,
    w1.point1 || ',' || w1.point2 AS tour,
    w1.cost FROM ways w1
    WHERE w1.point1 = 'a'

    UNION

    SELECT w2.point1, w2.point2,
        w1.tour || ',' || w2.point2 AS tour,
        w1.cost + w2.cost
    FROM cte_ways AS w1
    JOIN ways w2 ON w1.point2 = w2.point1
        AND w1.point1 <> w2.point2
    WHERE LENGTH(tour) < 8 -- ограничение точек в туре + запятые
)
SELECT cost AS total_cost, '{' || tour || '}' AS tour FROM cte_ways
WHERE LENGTH(tour) = 9 AND LEFT(tour, 1) = RIGHT(tour, 1)
    AND cost = (SELECT MIN(cost) FROM cte_ways
                WHERE LENGTH(tour) = 9 
                AND LEFT(tour, 1) = RIGHT(tour, 1))
ORDER BY total_cost, tour;