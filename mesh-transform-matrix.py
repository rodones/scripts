#!/usr/bin/env python
import numpy as np
from sys import argv
from numpy import arccos, sin, cos, deg2rad, rad2deg, sqrt


def getVector(p1, p2):
    return np.array([p2[0] - p1[0], p2[1] - p1[1], p2[2] - p1[2], 0.0])


def normalize(v):
    return v/np.linalg.norm(v)


def getTranslationMatrix(p):
    return np.array([[1, 0, 0, p[0]], [0, 1, 0, p[1]], [0, 0, 1, p[2]], [0, 0, 0, 1]])


def getScaleMatrix(s):
    return np.array([[s, 0, 0, 0], [0, s, 0, 0], [0, 0, s, 0], [0, 0, 0, 1]])


def getRotationMatrix(x, y, z):
    x = deg2rad(x)
    y = deg2rad(y)
    z = deg2rad(z)

    mX = np.array([[1, 0, 0, 0],
                   [0, cos(x), -sin(x), 0],
                   [0, sin(x), cos(x), 0],
                   [0, 0, 0, 1]])

    mY = np.array([[cos(y), 0, sin(y), 0],
                   [0, 1, 0, 0],
                   [-sin(y), 0, cos(y), 0],
                   [0, 0, 0, 1]])

    mZ = np.array([[cos(z), -sin(z), 0, 0],
                   [sin(z), cos(z), 0, 0],
                   [0, 0, 1, 0],
                   [0, 0, 0, 1]])

    return mX @ mY @ mZ


def getRodriguesRotationMatrix(theta, u):
    theta = deg2rad(theta)
    x, y, z = normalize(u)
    ct, st = cos(theta), sin(theta)
    return np.array([[ct + x**2 * (1-ct),       x*y*(1-ct)-z*st,    x*z*(1-ct)+y*st,    0],
                     [x * y * (1-ct) + z*st,    ct+y**2*(1-ct),     y*z*(1-ct) - x*st,  0],
                     [x*z*(1-ct)-y*st,          y*z*(1-ct)+x*st,    ct + z**2 * (1-ct), 0],
                     [0,                        0,                  0,                  1]])


def getLength(p1, p2):
    return sqrt((p1[0]-p2[0])**2+(p1[1]-p2[1])**2+(p1[2]-p2[2])**2)


def findAngleBetween(v1, v2):
    angleInRad = arccos(v1.dot(v2)/(np.linalg.norm(v1)*np.linalg.norm(v2)))
    angleInDegree = rad2deg(angleInRad)
    return angleInDegree


class Points:
    def __init__(self, p1, p2, p3):
        self.p1 = p1
        self.p2 = p2
        self.p3 = p3

    def getNormal(self):
        v1 = getVector(self.p1, self.p2)
        v2 = getVector(self.p2, self.p3)
        normalV = np.cross(v1[:3], v2[:3])
        return np.append(normalV, 0.0)

    def getCenterPoint(self):
        return np.average([self.p1, self.p2, self.p3], axis=0)

    def findAngleBetweenNormal(self, v2):
        v1 = self.getNormal()
        angleInRad = arccos(v1.dot(v2)/(np.linalg.norm(v1)*np.linalg.norm(v2)))
        angleInDegree = rad2deg(angleInRad)
        return angleInDegree

    def transform(self, matrix):
        self.p1 = matrix.dot(self.p1)
        self.p2 = matrix.dot(self.p2)
        self.p3 = matrix.dot(self.p3)


vecs = [[], []]
i=0
with open(argv[1]) as f:
    for line in f.readlines():
        if line.strip() == "":
            i = 1
        else:   
            vecs[i].append(np.array(tuple(map(float, line.strip().split(" "))) + (1,)))

P1 = Points(*vecs[0])
P2 = Points(*vecs[1])


M = np.identity(4)

m_temp = getScaleMatrix(getLength(P1.p1, P1.p2)/getLength(P2.p1, P2.p2))
M = m_temp @ M
P2.transform(m_temp)

n = np.cross(P2.getNormal()[:3], P1.getNormal()[:3])
a = P1.findAngleBetweenNormal(P2.getNormal())
m_temp = getRodriguesRotationMatrix(a, normalize(n))
M = m_temp @ M

P2.transform(m_temp)
afterA = P1.findAngleBetweenNormal(P2.getNormal())

m_temp = getTranslationMatrix(P1.p1 - P2.p1)
M = m_temp @ M
P2.transform(m_temp)

tempP1 = P1.p1
m_temp = getTranslationMatrix(-tempP1)
M = m_temp @ M
P1.transform(m_temp)

v1 = getVector(P1.p1, P1.p2)
v2 = getVector(P2.p1, P2.p2)
angle = findAngleBetween(v1, v2)
line = normalize(np.cross(v1[:3], v2[:3])[:3])

m_temp = getRodriguesRotationMatrix(360-angle, line)
M = m_temp @ M
P1.transform(m_temp)

m_temp = getTranslationMatrix(tempP1)
M = m_temp @ M
P1.transform(m_temp)

print("===============")
for m in M:
    for c in m:
        print(c, end=" ")
    print()
print("===============")

