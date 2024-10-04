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
    WHERE LENGTH(tour) < 8
)
SELECT cost AS total_cost, '{' || tour || '}' AS tour FROM cte_ways
WHERE LENGTH(tour) = 9 AND LEFT(tour, 1) = RIGHT(tour, 1)
ORDER BY total_cost, tour;