/*
 *  Geometry3D.h
 *
 * Copyright (c) 2010 Ryan Williams
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import <objc/objc.h>


#define Box3DIsEmpty(box) (box.size.width <= 0.0 || box.size.depth <= 0.0 || box.size.height <= 0.0)

typedef struct _Point3D
{
	float x;
	float y;
	float z;
} Point3D;

typedef struct _Size3D
{
	float width;
	float depth;
	float height;
} Size3D;

typedef struct _Box3D
{
	Point3D origin;
	Size3D size;
} Box3D;

Box3D b3d(float x, float y, float z, float w, float d, float h);
Size3D s3d(float w, float d, float h);
Point3D p3d(float x, float y, float z);
Point3D p3dAdd(Point3D p1, Point3D p2);
Point3D p3dSub(Point3D p1, Point3D p2);
Point3D p3dNeg(Point3D p);
float b3dMaxX(Box3D box);
float b3dMinX(Box3D box);
float b3dMaxY(Box3D box);
float b3dMinY(Box3D box);
float b3dMaxZ(Box3D box);
float b3dMinZ(Box3D box);

Box3D Box3DIntersection(Box3D box1, Box3D box2);
BOOL Box3DIntersectsBox3D(Box3D box1, Box3D box2);
