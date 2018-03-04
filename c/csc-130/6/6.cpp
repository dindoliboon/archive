// April 09, 2001
// Program #6

#include <iostream.h>
#include <fstream.h>
#include <math.h>

class Complex
{
	friend ostream & operator<<(ostream &, Complex &);
	friend istream & operator>>(istream &, Complex &);
	friend ofstream & operator<<(ofstream &, Complex &);
	friend ifstream & operator>>(ifstream &, Complex &);

	public:
		Complex(float = 0.0, float = 0.0);
		~Complex();
		Complex & operator+(Complex &);
		Complex & operator-(Complex &);
		Complex & operator*(Complex &);
		Complex & operator/(Complex &);

	private:
		float real;
		float fake;
};

Complex::Complex(float a, float b)
{
	real = a;
	fake = b;
}

Complex::~Complex()
{
	cout << "Deconstructor called.\n";
}

Complex & Complex::operator+(Complex &a)
{
	Complex *tempPt = new Complex;
	Complex &tempRef = *tempPt;

	tempPt -> real = real + a.real;
	tempPt -> fake = fake + a.fake;

	return tempRef;
}

Complex & Complex::operator-(Complex &a)
{
	Complex *tempPt = new Complex;
	Complex &tempRef = *tempPt;

	tempPt -> real = real - a.real;
	tempPt -> fake = fake - a.fake;

	return tempRef;
}

Complex & Complex::operator*(Complex &a)
{
	Complex *tempPt = new Complex;
	Complex &tempRef = *tempPt;

	tempPt -> real = (real * a.real) - (fake * a.fake);
	tempPt -> fake = (real * a.fake) + (fake * a.real);

	return tempRef;
}

Complex & Complex::operator/(Complex &a)
{
	Complex *tempPt = new Complex;
	Complex &tempRef = *tempPt;

	tempPt -> real = ((real * a.real) + (fake * a.fake)) / (pow(a.real, 2) + pow(a.fake, 2));
	tempPt -> fake = ((fake * a.fake) - (real * a.real)) / (pow(a.real, 2) + pow(a.fake, 2));

	return tempRef;
}

istream & operator>>(istream &input, Complex &a)
{
	cout << "Enter complex number (a + b):\n";
	input >> a.real;
	input.ignore(1);
	input >> a.fake;

	return input;
}

ostream & operator<<(ostream &output, Complex &a)
{
	output << a.real << " + " << a.fake << "i";
	return output;
}

ifstream & operator>>(ifstream &input, Complex &a)
{
	input.ignore(2);
	input >> a.real;
	input.ignore(3);
	input >> a.fake;
	input.ignore(1);

	return input;
}

int main()
{
	Complex a, b;
	ifstream fin;
	ofstream fot;
	char op;

	fot.open("asm6.out");
	fin.open("asm6.dat");
	while(!fin.eof() && fin >> op)
	{
		fin >> a >> b;

		switch(op)
		{
		case '+':
			cout << "(" << a << ") + (" << b << ") = (" << a + b << ")\n";
			fot << "(" << a << ") + (" << b << ") = (" << a + b << ")\n";
			break;
		case '-':
			cout << "(" << a << ") - (" << b << ") = (" << a - b << ")\n";
			fot << "(" << a << ") - (" << b << ") = (" << a - b << ")\n";
			break;
		case '*':
			cout << "(" << a << ") * (" << b << ") = (" << a * b << ")\n";
			fot << "(" << a << ") * (" << b << ") = (" << a * b << ")\n";
			break;
		case '/':
			cout << "(" << a << ") / (" << b << ") = (" << a / b << ")\n";
			fot << "(" << a << ") / (" << b << ") = (" << a / b << ")\n";
			break;
		default:
			cout << "Invalid operational code\n";
		}
	}
	fin.close();
	fot.close();

	return 0;
}
