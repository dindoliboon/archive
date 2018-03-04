// January 23, 2001
// Program #1, Part 2

#include <iostream.h>

int main()
{
	// 90 95 85 185 80 85 78 165 85 60 75 155 60 95 45 135 62 35 65 105

	// define variables
	const int num_students = 5;
	int students[4][5];
	int i, j, grade;

	// allow input
	for (i = 0; i < num_students; i++)
		for (j = 0; j < num_students - 1; j++)
			cin >> students[j][i];

	// process grades
	for (i = 0; i < num_students; i++)
	{
		grade = 0;
		for(j = 0; j < num_students - 1; j++)
			grade = grade + students[j][i];

		cout << "student #" << i+1 << " made an ";
		if (grade >= 450)
			cout << "A";
		else if (grade >= 400 && grade < 450)
			cout << "B";
		else if (grade >= 350 && grade < 400)
			cout << "C";
		else if (grade >= 300 && grade < 350)
			cout << "D";
		else
			cout << "E";
		cout << ".\n";
	}

	// return 0 for success
	return 0;
}
