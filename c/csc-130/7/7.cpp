// April 16, 2001
// Program #7

#include <iostream.h>
#include <fstream.h>
#include <math.h>

class Point{
	friend istream & operator>>(istream &, Point &);
	friend ostream & operator<<(ostream &, Point &);

	public:
		Point(float=0.0, float=0.0, float=0.0);
		~Point();
		float GetX();
		float GetY();
		float GetZ();
		void setPoint(float, float, float);
		void midPoint(Point &, Point &);
		float distance(Point &);

	protected:
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
	cout << "Point Deconstructor called.\n";
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

void Point::setPoint(float a, float b, float c)
{
	x = a;
	y = b;
	z = c;
}

void Point::midPoint(Point &a, Point &b)
{
	x = (a.x + b.x) / 2.0;
	y = (a.y + b.y) / 2.0;
	z = (a.z + b.z) / 2.0;
}

float Point::distance(Point &a)
{
	return sqrt(pow(a.x - x, 2.0) + pow(a.y - y, 2.0) + pow(a.z - z, 2.0));
}

istream & operator>>(istream &input, Point &a)
{
	char ignore;

	cout << "Enter a point in the format (1.2, 3.4, 5.6)\n";
	input >> ignore >> a.x >> ignore >> a.y >> ignore >> a.z >> ignore;

	return input;
}

ostream & operator<<(ostream &output, Point &a)
{
	output << "(" << a.x << ", " << a.y << ", " << a.z << ")";

	return output;
}

class Sphere : public Point{
	friend istream & operator>>(istream &, Sphere &);
	friend ostream & operator<<(istream &, Sphere &);

	public:
		Sphere(float=0.0, float=0.0, float=0.0, float=0.0);
		~Sphere();
		void setRadius(float);
		void setSphere(float, float, float, float);
		float distance(Point &);
		float distance(Sphere &);
		float GetRadius();
		float surfaceArea();
		float volume();

	protected:
		float radius;
};

Sphere::Sphere(float a, float b, float c, float d)
{
	setSphere(a, b, c, d);
}

Sphere::~Sphere()
{
	cout << "Sphere Deconstructor called.\n";
}

void Sphere::setRadius(float a)
{
	radius = a;
}

void Sphere::setSphere(float a, float b, float c, float d)
{
	setPoint(a, b, c);
	setRadius(d);
}

float Sphere::distance(Point &a)
{
	Point *ppt = new Point;
	Point &prf = *ppt;

	prf.setPoint(Point::GetX(), Point::GetY(), Point::GetZ());

	return a.distance(prf) - radius;
}

float Sphere::distance(Sphere &a)
{
	return sqrt(pow(a.Point::GetX() - Point::GetX(), 2.0) + pow(a.Point::GetY() - Point::GetY(), 2.0) + pow(a.Point::GetZ() - Point::GetZ(), 2.0)) - (radius + a.radius);
}

float Sphere::surfaceArea()
{
	return  4.0 * 3.1416 * radius;
}

float Sphere::volume()
{
	return  3.0 * 3.1416 * pow(radius, 3.0) / 4.0;
}

float Sphere::GetRadius()
{
	return radius;
}

istream & operator>>(istream &input, Sphere &a)
{
	Sphere *spt = &a;
	Point *ppt = (Point*) spt;
	
	cout << "For the center of sphere:\n";
	cin >> *ppt;
	cout << "Enter the radius of sphere:\n";
	input >> a.radius;

	return input;
}

ostream & operator<<(ostream &output, Sphere &a)
{
	output << "Sphere{(" << a.Point::GetX() << ", " << a.Point::GetY() << ", " << a.Point::GetZ() << "), " << a.GetRadius() << "}";
	return output;
}

int main()
{
	void Handle_Midpoint(Point &, Point &, Point &);
	void Handle_Distance(Point &, Point &);
	void Handle_Distance(Point &, Sphere &);
	void Handle_Distance(Sphere &, Sphere &);
	void Handle_Position(Point &, Sphere &);
	void Handle_Position(Sphere &, Sphere &);
	void Handle_Area(Sphere &);
	void Handle_Volume(Sphere &);

	Point p1, p2, p3;
	Sphere s1, s2;
	int choice = 0;

	while (choice != 9)
	{
		cout << "************************ MEMU ************************************\n";
		cout << "* 1. Find midpoint between two points.                           *\n";
		cout << "* 2. Find distance between two points.                           *\n";
		cout << "* 3. Find distance between a point and a sphere.                 *\n";
		cout << "* 4. Find distance between two spheres.                          *\n";
		cout << "* 5. Determine relative position between a point and a sphere.   *\n";
		cout << "* 6. Determine relative position between two spheres.            *\n";
		cout << "* 7. Find the surface area of a sphere.                          *\n";
		cout << "* 8. Find the volume of a sphere.                                *\n";
		cout << "* 9. Exit the program.                                           *\n";
		cout << "******************************************************************\n";

		cout << "Enter your choice 1 - 9 now: ";
		cin >> choice;

		switch (choice)
		{
		case 1:
			Handle_Midpoint(p1, p2, p3);
			break;
		case 2:
			Handle_Distance(p1, p2);
			break;
		case 3:
			Handle_Distance(p1, s1);
			break;
		case 4:
			Handle_Distance(s1, s2);
			break;
		case 5:
			Handle_Position(p1, s1);
			break;
		case 6:
			Handle_Position(s1, s2);
			break;
		case 7:
			Handle_Area(s1);
			break;
		case 8:
			Handle_Volume(s1);
			break;
		case 9:
			break;
		default:
			cout << "Invalid choice\n";
		}
	}

	return 0;
}

void Handle_Midpoint(Point &p1, Point &p2, Point &p3)
{
	cout << "You want to find the midpoint of two points:\n";
	cin >> p1;
	cin >> p2;
	p3.midPoint(p1, p2);
	cout << "The midpoint between " << p1 << " and " << p2 << " is " << p3 << endl;
}

void Handle_Distance(Point &p1, Point &p2)
{
	cout << "Find distance between two points.\n";
	cin >> p1 >> p2;
	cout << "The distance between " << p1 << " and " << p2 << " is " << p1.distance(p2) << endl;
}

void Handle_Distance(Point &p1, Sphere &s1)
{
	cout << "Find distance between a point and a sphere.\n";
	cin >> p1 >> s1;
	cout << "The distance between " << p1 << " and Sphere" << s1 << " is " << s1.distance(p1) << endl;
}

void Handle_Distance(Sphere &s1, Sphere &s2)
{
	cout << "Find distance between two spheres.\n";
	cin >> s1 >> s2;
	cout << "The distance between Sphere" << s1 << " and Sphere" << s2 << " is " << s1.distance(s2) << endl;
}

void Handle_Position(Point &p1, Sphere &s1)
{
	cout << "Determine relative position between a point and a sphere.\n";
	cin >> p1 >> s1;
	if (s1.distance(p1) == 0)
		cout << "The point " << p1 << " is on " << s1 << endl;
	else if (s1.distance(p1) > 0)
		cout << "The point " << p1 << " is outside " << s1 << endl;
	else
		cout << "The point " << p1 << " is inside " << s1 << endl;
}

void Handle_Position(Sphere &s1, Sphere &s2)
{
	cout << "Determine relative position between two spheres.\n";
	cin >> s1 >> s2;

	if (s1.distance(s2) == 0)
		cout << s1 << " is tangential to " << s2 << endl;
	else if (s1.distance(s2) > 0)
		cout << s1 << " and " << s2 << " are disjoint." << endl;
	else 
		cout << s1 <<" and " << s2 <<" intersect." << endl;
}

void Handle_Area(Sphere &s1)
{
	cout << "Find the surface area of a sphere.\n";
	cin >> s1;
	cout << "The surface area of " << s1 << " is " << s1.surfaceArea() << endl;
}

void Handle_Volume(Sphere &s1)
{
	cout << "Find the volume of a sphere.\n";
	cin >> s1;
	cout << "The volume of " << s1 << " is " << s1.volume() << endl;
}
