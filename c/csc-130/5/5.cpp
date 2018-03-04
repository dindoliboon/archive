// March 28, 2001
// Program #5

#include <iostream.h>
#include <fstream.h>
#include <math.h>

class Point
{
	public:
		Point(float = 0.0, float = 0.0, float = 0.0);
		~Point();
		void SetValue(float, float, float);
		float GetX();
		float GetY();
		float GetZ();
		float Distance(Point &);
		void Add(Point &);
		void Subtract(Point &);
		void Multiply(Point &);
		void ToScreen();
		void ToFile(ofstream *);

	private:
		float x;
		float y;
		float z;
};

Point::Point(float a, float b, float c)
{
	x = a;
	y = b;
	z = c;
}

Point::~Point()
{
	cout << "Deconstructor called.\n";
}

void Point::SetValue(float a, float b, float c)
{
	x = a;
	y = b;
	z = c;
}

float Point::GetX()
{
	return x;
}

float Point::GetY()
{
	return y;
}

float Point::GetZ()
{
	return z;
}

float Point::Distance(Point &a)
{
	return sqrt(pow(a.GetX() - x, 2) + pow(a.GetY() - y, 2) + pow(a.GetZ() - z, 2));
}

void Point::Add(Point &a)
{
	x = x + a.GetX();
	y = y + a.GetY();
	z = z + a.GetZ();
}

void Point::Subtract(Point &a)
{
	x = x - a.GetX();
	y = y - a.GetY();
	z = z - a.GetZ();
}

void Point::Multiply(Point &a)
{
	x = x * a.GetX();
	y = y * a.GetY();
	z = z * a.GetZ();
}

void Point::ToScreen()
{
	cout << "(" << x << ", " << y << ", " << z << ")";
}

void Point::ToFile(ofstream *fp)
{
	*fp  << "(" << x << ", " << y << ", " << z << ")";
}

int main()
{
	Point a, b;
	ifstream fin;
	ofstream fot;
	int op;
	float u, v, w, x, y, z;

	fot.open("asm5.out");
	fin.open("asm5.dat");
	while(!fin.eof() && fin >> op)
	{
		fin.ignore(3);
		fin >> u;
		fin.ignore(2);
		fin >> v;
		fin.ignore(2);
		fin >> w;
		fin.ignore(4);
		fin >> x;
		fin.ignore(2);
		fin >> y;
		fin.ignore(2);
		fin >> z;
		fin.ignore(2);

		a.SetValue(u, v, w);
		b.SetValue(x, y, z);

		switch(op)
		{
		case 1:
			a.ToScreen();
			a.ToFile(&fot);
			cout << " + ";
			fot << " + ";
			b.ToScreen();
			b.ToFile(&fot);
			cout << " = ";
			fot << " = ";
			a.Add(b);
			a.ToScreen();
			a.ToFile(&fot);
			cout << endl;
			fot << endl;
			break;
		case 2:
			a.ToScreen();
			a.ToFile(&fot);
			cout << " - ";
			fot << " - ";
			b.ToScreen();
			b.ToFile(&fot);
			cout << " = ";
			fot << " = ";
			a.Subtract(b);
			a.ToScreen();
			a.ToFile(&fot);
			cout << endl;
			fot << endl;
			break;
		case 3:
			a.ToScreen();
			a.ToFile(&fot);
			cout << " * ";
			fot << " * ";
			b.ToScreen();
			b.ToFile(&fot);
			cout << " = ";
			fot << " = ";
			a.Multiply(b);
			a.ToScreen();
			a.ToFile(&fot);
			cout << endl;
			fot << endl;
			break;
		case 4:
			cout << "The distance of ";
			fot << "The distance of ";
			a.ToScreen();
			a.ToFile(&fot);
			cout << " from ";
			fot  << " from ";
			b.ToScreen();
			b.ToFile(&fot);
			cout << " is " << a.Distance(b) << endl;
			fot << " is " << a.Distance(b) << endl;
			break;
		default:
			cout << "Invalid operational code\n";
		}
	}
	fin.close();
	fot.close();

	return 0;
}
