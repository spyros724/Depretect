#include <iostream>
#include <stdexcept>
#include <iomanip>
using namespace std;

class ChessBoardArray {
protected:
	class Row {
	public:
		Row(ChessBoardArray &a, int i) : array(a), row(i) {}
			
		int & operator [] (int i) const{
			return array.select(row, i);  
		}
	private:
		ChessBoardArray &array;
		int row;
	};
	
	class ConstRow {
	public:
		ConstRow(const ChessBoardArray &a, int i) : array(a), row(i) {}
		
		int operator [] (int i) const {
		   return array.select(row, i);
		}
	private:
		const ChessBoardArray &array;
		int row;
	};
	
public:
	ChessBoardArray(unsigned size=0, unsigned base=0) {
		if(size%2==1){
		real_size=((size*size)/2)+1;
	    }
	    if(size%2==0){
		real_size=((size*size)/2);
	    }
		data=new int[real_size];
		first=base;
		num=size;
		for(int i=0; i<real_size; i++) {
			data[i]=0;
		}
	}
	
	ChessBoardArray(const ChessBoardArray &a) {
		real_size=a.real_size;
		data=new int[a.real_size];
		first=a.first;
		num=a.num;
		for(int i=0; i<a.real_size; i++) {
			data[i]=a.data[i];
		}
	}
	
	~ChessBoardArray() {
		delete [] data;
	}
	
	ChessBoardArray & operator = (const ChessBoardArray &a) {
		delete [] data;
		real_size=a.real_size;
		data=new int[a.real_size];
		first=a.first;
		num=a.num;
		for(int i=0; i<a.real_size; i++) {
			data[i]=a.data[i];
		}
		return *this;
	}
	
	int & select(int i, int j) {
		return data[loc(i, j)];
	}
	
	int select(int i, int j) const {
		return data[loc(i, j)];
	}
	
	const Row operator [] (int i) {
		return Row(*this, i);
	}
	
	const ConstRow operator [] (int i) const {
		return ConstRow(*this, i);
	}
	
	friend ostream & operator << (ostream &out, const ChessBoardArray &a) {
		for(int i=a.first; i<a.first+a.num; i++) {
			for(int j=a.first; j<a.first+a.num; j++){
				if((i+j)%2==0) {
			        out<<setw(4);
			        out<<a.select(i,j);
		        }
		        if((i+j)%2==1) {
		        	out<<setw(4);
		        	out<<0;
				}
			}
			out<<endl;
		}
		return out;
	}

private:
	int real_size;
	int *data;
	int first;
	int num;
	unsigned int loc(int i, int j) const throw(out_of_range) {
		int di=i-first;
		int dj=j-first;
		if(di<0 || di>=num || dj<0 || dj>=num || ((i+j)%2==1)) {
			throw out_of_range("Houston we have a problem");
		}
		return (di*num+dj)/2;
	}
};
