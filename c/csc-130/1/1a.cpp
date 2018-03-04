// January 23, 2001
// Program #1, Part 1

#include <iostream.h>

int main()
{
	const int max_data = 10;
	int data[10] = {20, -4, 6, 10, -15, -10, -20, 4, -6, 15};
	int i, j, tmp;
	char answer;

	cout << "Do you want to use a new set of numbers [y/n]? ";
	cin >> answer;

	switch (answer)
	{
	case 'N':
	case 'n':
		break;
	default :
		for (i = 0; i < max_data; i++)
			cin >> data[i];
	}

	for (i = 0; i < max_data; i++)
	{
		cout << data[i];
		(i == (max_data - 1) ? cout << endl : cout << ' ');
	}

	for (i = 0; i < max_data - 1; i++)
		for (j = i + 1; j < max_data; j++)
			if (data[i] > data[j])
			{
				tmp = data[j];
				data[j] = data[i];
				data[i] = tmp;
			}

	for (i = 0; i < max_data; i++)
	{
		cout << data[i];
		(i == (max_data - 1) ? cout << endl : cout << ' ');
	}

	return 0;
}
