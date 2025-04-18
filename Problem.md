# Hard Transportation Hub

Given the map of a country, there could be more than one shortest path between any pair of cities.  A **transportation hub** is a city that is on no less than $k$ shortest paths (the source and the destination NOT included).  Your job is to find, for a given pair of cities, the transportation hubs on the way.
**Note:** the shortest path length from $v$ to itself is defined to be 0.

### Input Specification:
Each input file contains one test case. For each case, the first line gives three positive integers $n$ ($3 \le n \le 500$), $m$ and $k$ ($1< k \le 5$), being the total number of cities, the number of roads connecting those cities, and the threshold (阈值) for a transportation hub, respectively. Then $m$ lines follow, each describes a road in the format:
```
c1 c2 length
```
where `c1` and `c2` are the city indices (from 0 to $n-1$) of the two ends of the road; `length` is the length of the road, which is a positive integer that is no more than 100.  It is guaranteed that all the roads are two-way roads, and there is no duplicated information for any road.
Then another positive integer $T$ ($\le 500$) is given, followed by $T$ lines, each gives a pair of source and destination.
### Output Specification:
For each pair of source and destination, list all the transportation hubs in ascending order of their indices, in a line.  All the numbers in a line must be separated by 1 space, and there must be no extra space at the beginning or the end of the line.
In case that there is no transportation hub, simply print `None` in the line.
### Sample Input:
```in
10 16 2
1 2 1
1 3 1
1 4 2
2 4 1
2 5 2
3 4 1
3 0 1
4 5 1
4 6 2
5 6 1
7 3 2
7 8 1
7 0 3
8 9 1
9 0 2
0 6 2
3
1 6
7 0
5 5

```
### Sample Output:
```out
2 3 4 5
None
None

```
### Grading Policy:

- Chapter 1: Introduction (6 pts.)
- Chapter 2: Algorithm Specification (12 pts.)
- Chapter 3: Testing Results (20 pts.)
- Chapter 4: Analysis and Comments (10 pts.)
- Write the program (50 pts.) with sufficient comments.
- Overall style of documentation (2 pts.)

