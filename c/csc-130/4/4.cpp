// March 19, 2001
// Program #4

#include <iostream.h>
#include <fstream.h>

class Complex
{
	public:
		Complex(float = 0.0, float = 0.0);
		~Complex();
		void SetValue(float, float);
		float GetR();
		float GetI();
		void Add(Complex &);
		void Subtract(Complex &);
		void Multiply(Complex &);
		void ToScreen();
		void ToFile(ofstream *);

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

void Complex::SetValue(float a, float b)
{
	real = a;
	fake = b;
}

float Complex::GetR()
{
	return real;
}

float Complex::GetI()
{
	return fake;
}

void Complex::Add(Complex &a)
{
	real = real + a.real;
	fake = fake + a.fake;
}

void Complex::Subtract(Complex &a)
{
	real = real - a.real;
	fake = fake - a.fake;
}

void Complex::Multiply(Complex &a)
{
	Complex *tempPt = new Complex;

	tempPt -> real = (real * a.real) - (fake * a.fake);
	tempPt -> fake = (real * a.fake) + (fake * a.real);

	real = tempPt -> real;
	fake = tempPt -> fake;
}

void Complex::ToScreen()
{
	cout << "(" << real << " + " << fake << "i)";
}

void Complex::ToFile(ofstream *fp)
{
	*fp  << "(" << real << " + " << fake << "i)";
}

int main()
{
	Complex a, b;
	ifstream fin;
	ofstream fot;
	char op;
	float w, x, y, z;

	fot.open("asm4.out");
	fin.open("asm4.dat");
	while(!fin.eof() && fin >> op)
	{
		fin.ignore(2);
		fin >> w;
		fin.ignore(3);
		fin >> x;
		fin.ignore(3);
		fin >> y;
		fin.ignore(3);
		fin >> z;
		fin.ignore(2);

		a.SetValue(w, x);
		b.SetValue(y, z);

		switch(op)
		{
		case '+':
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
		case '-':
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
		case '*':
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
		default:
			cout << "Invalid operational code\n";
		}
	}
	fin.close();
	fot.close();

	return 0;
}
