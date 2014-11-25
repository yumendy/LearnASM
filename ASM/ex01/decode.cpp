#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <iostream>

using namespace std;

int main(int argc, char const *argv[])
{
	char str[1000];
	memset(str,0,1000);
	str[0] = str[1] = 0;
	char *c = str + 2;
	int result = 0x0;
	unsigned int temp;
	int j = 0;

	cin >> c;
	getchar();
	int len = strlen(c);

	unsigned int  iSum = 0;
	unsigned int *pInt;
	pInt = (unsigned int *)c;
	for (int i = 0; i < ((len+3)/4); i++)
	{
		iSum += (*pInt);
		pInt++;
	}
	//cout << iSum << endl;
	cout << iSum % 100000 << endl;

	c += len - 1;
	for (int i = (len + 2) * 8 - 1; i >= 0; --i)
	{
		if (((result >> 16) & 0x0001) == 0x01)
		{
			result = result ^ 0x18005;
		}
		result <<= 1;
		temp = (*c >> (i % 8)) & 0x0001;
		result |= temp;
		if (++j >= 8)
		{
			j = 0;
			c--;
		}
	}

	if (((result >> 16) & 0x01) == 0x01)
	{
		result = result ^ 0x18005;
	}

	printf("%04X\n", result);
	system("pause");
	return 0;
}
