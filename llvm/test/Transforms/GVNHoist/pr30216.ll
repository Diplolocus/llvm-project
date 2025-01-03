; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 2
; RUN: opt -S -passes=gvn-hoist < %s | FileCheck %s

; Make sure the two stores @B do not get hoisted past the load @B.

@A = external global i8
@B = external global ptr

define ptr @Foo(i1 %arg) {
; CHECK-LABEL: define ptr @Foo(i1 %arg) {
; CHECK-NEXT:    store i8 0, ptr @A, align 1
; CHECK-NEXT:    br i1 %arg, label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    store ptr null, ptr @B, align 8
; CHECK-NEXT:    ret ptr null
; CHECK:       if.else:
; CHECK-NEXT:    [[TMP1:%.*]] = load ptr, ptr @B, align 8
; CHECK-NEXT:    store ptr null, ptr @B, align 8
; CHECK-NEXT:    ret ptr [[TMP1]]
;
  store i8 0, ptr @A
  br i1 %arg, label %if.then, label %if.else

if.then:
  store ptr null, ptr @B
  ret ptr null

if.else:
  %1 = load ptr, ptr @B
  store ptr null, ptr @B
  ret ptr %1
}

; Make sure the two stores @B do not get hoisted past the store @GlobalVar.

@GlobalVar = internal global i8 0

define ptr @Fun(i1 %arg) {
; CHECK-LABEL: define ptr @Fun(i1 %arg) {
; CHECK-NEXT:    store i8 0, ptr @A, align 1
; CHECK-NEXT:    br i1 %arg, label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    store ptr null, ptr @B, align 8
; CHECK-NEXT:    ret ptr null
; CHECK:       if.else:
; CHECK-NEXT:    store i8 0, ptr @GlobalVar, align 1
; CHECK-NEXT:    store ptr null, ptr @B, align 8
; CHECK-NEXT:    [[TMP1:%.*]] = load ptr, ptr @B, align 8
; CHECK-NEXT:    ret ptr [[TMP1]]
;
  store i8 0, ptr @A
  br i1 %arg, label %if.then, label %if.else

if.then:
  store ptr null, ptr @B
  ret ptr null

if.else:
  store i8 0, ptr @GlobalVar
  store ptr null, ptr @B
  %1 = load ptr, ptr @B
  ret ptr %1
}
