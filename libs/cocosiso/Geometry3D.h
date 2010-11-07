/*
 *  Geometry3D.h
 *
 *  Created by Ryan Williams on 7/08/10.
 *  Copyright 2010 Ryan Williams All rights reserved.
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
