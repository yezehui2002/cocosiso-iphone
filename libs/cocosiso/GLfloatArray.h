/*
 *  GLfloatArray.h
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

