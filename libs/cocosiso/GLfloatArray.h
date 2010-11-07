/*
 *  GLfloatArray.h
 *
 *  Created by Ryan Williams on 15/08/10.
 *  Copyright 2010 Ryan Williams All rights reserved.
 *
 */



typedef struct _GLfloatArray {
	NSUInteger num, max;
	GLfloat *arr;
} GLfloatArray;

static inline GLfloatArray* GLfloatArrayNew(NSUInteger capacity)
{
	if (capacity == 0)
		capacity = 1; 
	
	GLfloatArray *arr = (GLfloatArray*)malloc( sizeof(GLfloatArray) );
	arr->num = 0;
	arr->arr =  (GLfloat*) malloc( capacity * sizeof(GLfloat) );
	arr->max = capacity;
	
	return arr;	
}

static inline void GLfloatArrayFree(GLfloatArray *arr)
{
	if( arr == nil ) return;
	
	free(arr->arr);
	free(arr);
}

/** Doubles array capacity */
static inline void GLfloatArrayDoubleCapacity(GLfloatArray *arr)
{
	arr->max *= 2;
	arr->arr = (GLfloat*) realloc( arr->arr, arr->max * sizeof(GLfloat) );
}

/** Increases array capacity such that max >= num + extra. */
static inline void GLfloatArrayEnsureExtraCapacity(GLfloatArray *arr, NSUInteger extra)
{
	while (arr->max < arr->num + extra)
		GLfloatArrayDoubleCapacity(arr);
}

/** Appends an value. Bahaviour undefined if array doesn't have enough capacity. */
static inline void GLfloatArrayAppendValue(GLfloatArray *arr, GLfloat value)
{
	arr->arr[arr->num] = value;
	arr->num++;
}


/** Appends an value. Capacity of arr is increased if needed. */
static inline void GLfloatArrayAppendValueWithResize(GLfloatArray *arr, GLfloat value)
{
	GLfloatArrayEnsureExtraCapacity(arr, 1);
	GLfloatArrayAppendValue(arr, value);
}

/** Appends values from plusArr to arr. Behaviour undefined if arr doesn't have
 enough capacity. */
static inline void GLfloatArrayAppendArray(GLfloatArray *arr, GLfloatArray *plusArr)
{
	for( NSUInteger i = 0; i < plusArr->num; i++)
		GLfloatArrayAppendValue(arr, plusArr->arr[i]);
}

/** Appends values from plusArr to arr. Capacity of arr is increased if needed. */
static inline void GLfloatArrayAppendArrayWithResize(GLfloatArray *arr, GLfloatArray *plusArr)
{
	GLfloatArrayEnsureExtraCapacity(arr, plusArr->num);
	GLfloatArrayAppendArray(arr, plusArr);
}



static inline void GLfloatArrayCopyFromCArray(GLfloatArray *arr, GLfloat *carr, NSUInteger size)
{
	memcpy(arr->arr, carr, sizeof(GLfloat) * size);
	arr->num = size;

}

