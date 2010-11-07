/*
 *  Geometry3D.c
 *
 *  Created by Ryan Williams on 8/08/10.
 *  Copyright 2010 Ryan Williams All rights reserved.
 *
 */

#import "Geometry3D.h"

#if !defined(MIN)
	#define MIN(A,B)	({ __typeof__(A) __a = (A); __typeof__(B) __b = (B); __a < __b ? __a : __b; })
#endif

#if !defined(MAX)
	#define MAX(A,B)	({ __typeof__(A) __a = (A); __typeof__(B) __b = (B); __a < __b ? __b : __a; })
#endif


Box3D b3d(float x, float y, float z, float w, float d, float h)
{
	return (Box3D){
		p3d(x, y, z),
		s3d(w, d, h)
	};
}

Size3D s3d(float w, float d, float h)
{
	return (Size3D){w, d, h};
}

Point3D p3d(float x, float y, float z)
{
	return (Point3D){x, y, z};
}

Point3D p3dAdd(Point3D p1, Point3D p2)
{
	return p3d(p1.x + p2.x, p1.y + p2.y, p1.z + p2.z);
}

Point3D p3dSub(Point3D p1, Point3D p2)
{
	return p3d(p1.x - p2.x, p1.y - p2.y, p1.z - p2.z);
}

Point3D p3dNeg(Point3D p)
{
	return p3d(-p.x, -p.y, -p.z);
}

float b3dMaxX(Box3D box)
{
	return box.origin.x + box.size.width;
}
float b3dMinX(Box3D box)
{
	return box.origin.x;
}
float b3dMaxY(Box3D box)
{
	return box.origin.y + box.size.depth;
}
float b3dMinY(Box3D box)
{
	return box.origin.y;
}
float b3dMaxZ(Box3D box)
{
	return box.origin.z + box.size.height;
}
float b3dMinZ(Box3D box)
{
	return box.origin.z;
}

Box3D Box3DIntersection(Box3D box1, Box3D box2)
{
    Box3D intersection = b3d(
        MAX(box1.origin.x, box2.origin.x),
        MAX(box1.origin.y, box2.origin.y),
        MAX(box1.origin.z, box2.origin.z),
        0, 0, 0
    );

    intersection.size.width  = MIN(b3dMaxX(box1), b3dMaxX(box2)) - intersection.origin.x;
    intersection.size.depth  = MIN(b3dMaxY(box1), b3dMaxY(box2)) - intersection.origin.y;
    intersection.size.height = MIN(b3dMaxZ(box1), b3dMaxZ(box2)) - intersection.origin.z;

    return Box3DIsEmpty(intersection) ? b3d(0,0,0, 0,0,0) : intersection;
}

BOOL Box3DIntersectsBox3D(Box3D box1, Box3D box2)
{
	return !Box3DIsEmpty(Box3DIntersection(box1, box2));
}
