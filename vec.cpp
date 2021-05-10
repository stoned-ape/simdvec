#include <iostream>
using namespace std;

struct vec4{
    float x,y,z,w;
    vec4(float _x,float _y,float _z,float _w):x(_x),y(_y),z(_z),w(_w){};
    vec4(float f):x(f),y(f),z(f),w(f){};
    vec4():x(0),y(0),z(0),w(0){};
    float operator[](int i){
        float *f=(float*)this;
        return f[i];
    }
    friend ostream &operator<<(ostream &os,vec4 v){
        os<<"["<<v.x<<","<<v.y<<","<<v.z<<","<<v.w<<"]"<<"\n";
        return os;
    }
};

//these functions are defined in assembly to use special
//simd x86 instructions
extern "C" void vadd(vec4 *a,vec4 *b,vec4 *c);
extern "C" void vsub(vec4 *a,vec4 *b,vec4 *c);
extern "C" void vmul(vec4 *a,vec4 *b,vec4 *c);
extern "C" void vdiv(vec4 *a,vec4 *b,vec4 *c);
extern "C" void vmax(vec4 *a,vec4 *b,vec4 *c);
extern "C" void vmin(vec4 *a,vec4 *b,vec4 *c);
extern "C" float vdot(vec4 *a,vec4 *b);
extern "C" float vlength(vec4 *a);
extern "C" void vnorm(vec4 *a,vec4 *c);


//defining operators for vector arithmatic
vec4 operator+(vec4 a,vec4 b){
    vec4 *c= new vec4();
    vadd(&a,&b,c);
    return *c;
}
vec4 operator-(vec4 a,vec4 b){
    vec4 *c= new vec4();
    vsub(&a,&b,c);
    return *c;
}
vec4 operator*(vec4 a,vec4 b){
    vec4 *c= new vec4();
    vmul(&a,&b,c);
    return *c;
}
vec4 operator/(vec4 a,vec4 b){
    vec4 *c= new vec4();
    vdiv(&a,&b,c);
    return *c;
}
vec4 max(vec4 a,vec4 b){
    vec4 *c= new vec4();
    vmax(&a,&b,c);
    return *c;
}
vec4 min(vec4 a,vec4 b){
    vec4 *c= new vec4();
    vmin(&a,&b,c);
    return *c;
}
float dot(vec4 a,vec4 b){return vdot(&a,&b);}
float length(vec4 a){return vlength(&a);}
vec4 normalize(vec4 a){
    vec4 *c= new vec4();
    vnorm(&a,c);
    return *c;
}

int main(){
    vec4 v(1,2,3,4);
    vec4 u(4,3,2,1);
    
    cout<<"u="<<u;
    cout<<"v="<<v;
    
    cout<<"element wise operations:\n";
    cout<<"\tu+v="<<u+v;
    cout<<"\tu-v="<<u-v;
    cout<<"\tu*v="<<u*v;
    cout<<"\tu/v="<<u/v;
    cout<<"\tmin(u,v)="<<min(u,v);
    cout<<"\tmax(u,v)="<<max(u,v);

    cout<<"normalize(v)="<<normalize(v);
    cout<<"length(v)="<<length(v)<<endl;
    cout<<"dot(u,v)="<<dot(u,v)<<endl;
    
}


