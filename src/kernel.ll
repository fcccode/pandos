; ModuleID = 'src/kernel.c'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i686-pc-none-elf"

@terminal_row = common global i32 0, align 4
@terminal_column = common global i32 0, align 4
@terminal_color = common global i8 0, align 1
@terminal_buffer = common global i16* null, align 4
@.str = private unnamed_addr constant [22 x i8] c"Hello, kernel World!\0A\00", align 1

; Function Attrs: nounwind readnone
define zeroext i8 @make_color(i32 %fg, i32 %bg) #0 {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fg}, i64 0, metadata !30), !dbg !112
  tail call void @llvm.dbg.value(metadata !{i32 %bg}, i64 0, metadata !31), !dbg !112
  %shl = shl i32 %bg, 4, !dbg !113
  %or = or i32 %shl, %fg, !dbg !113
  %conv = trunc i32 %or to i8, !dbg !113
  ret i8 %conv, !dbg !113
}

; Function Attrs: nounwind readnone
define zeroext i16 @make_vgaentry(i8 signext %c, i8 zeroext %color) #0 {
entry:
  tail call void @llvm.dbg.value(metadata !{i8 %c}, i64 0, metadata !39), !dbg !114
  tail call void @llvm.dbg.value(metadata !{i8 %color}, i64 0, metadata !40), !dbg !114
  %conv = sext i8 %c to i16, !dbg !115
  tail call void @llvm.dbg.value(metadata !{i8 %c}, i64 0, metadata !41), !dbg !115
  %conv3 = zext i8 %color to i16, !dbg !116
  %shl = shl nuw i16 %conv3, 8, !dbg !116
  %or = or i16 %shl, %conv, !dbg !116
  ret i16 %or, !dbg !116
}

; Function Attrs: nounwind readonly
define i32 @strlen(i8* nocapture readonly %str) #1 {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %str}, i64 0, metadata !51), !dbg !117
  tail call void @llvm.dbg.value(metadata !21, i64 0, metadata !52), !dbg !118
  br label %while.cond, !dbg !119

while.cond:                                       ; preds = %while.cond, %entry
  %ret.0 = phi i32 [ 0, %entry ], [ %inc, %while.cond ]
  %arrayidx = getelementptr inbounds i8* %str, i32 %ret.0, !dbg !119
  %0 = load i8* %arrayidx, align 1, !dbg !119, !tbaa !120
  %cmp = icmp eq i8 %0, 0, !dbg !119
  %inc = add i32 %ret.0, 1, !dbg !123
  tail call void @llvm.dbg.value(metadata !{i32 %inc}, i64 0, metadata !52), !dbg !123
  br i1 %cmp, label %while.end, label %while.cond, !dbg !119

while.end:                                        ; preds = %while.cond
  ret i32 %ret.0, !dbg !124
}

; Function Attrs: nounwind
define void @terminal_initialize() #2 {
entry:
  store i32 0, i32* @terminal_row, align 4, !dbg !125, !tbaa !126
  store i32 0, i32* @terminal_column, align 4, !dbg !128, !tbaa !126
  tail call void @llvm.dbg.value(metadata !129, i64 0, metadata !130), !dbg !132
  tail call void @llvm.dbg.value(metadata !21, i64 0, metadata !133), !dbg !132
  store i8 7, i8* @terminal_color, align 1, !dbg !131, !tbaa !120
  store i16* inttoptr (i32 -1072988160 to i16*), i16** @terminal_buffer, align 4, !dbg !134, !tbaa !135
  tail call void @llvm.dbg.value(metadata !21, i64 0, metadata !57), !dbg !137
  br label %for.cond1.preheader, !dbg !137

for.cond1.preheader:                              ; preds = %for.inc5, %entry
  %y.012 = phi i32 [ 0, %entry ], [ %inc6, %for.inc5 ]
  %mul = mul i32 %y.012, 80, !dbg !138
  br label %for.body3, !dbg !139

for.body3:                                        ; preds = %for.body3, %for.cond1.preheader
  %x.011 = phi i32 [ 0, %for.cond1.preheader ], [ %inc, %for.body3 ]
  %add = add i32 %x.011, %mul, !dbg !138
  tail call void @llvm.dbg.value(metadata !{i32 %add}, i64 0, metadata !62), !dbg !138
  %0 = load i8* @terminal_color, align 1, !dbg !140, !tbaa !120
  tail call void @llvm.dbg.value(metadata !141, i64 0, metadata !142), !dbg !143
  tail call void @llvm.dbg.value(metadata !{i8 %0}, i64 0, metadata !144), !dbg !143
  tail call void @llvm.dbg.value(metadata !141, i64 0, metadata !145), !dbg !146
  %conv3.i = zext i8 %0 to i16, !dbg !147
  %shl.i = shl nuw i16 %conv3.i, 8, !dbg !147
  %or.i = or i16 %shl.i, 32, !dbg !147
  %arrayidx = getelementptr inbounds i16* inttoptr (i32 -1072988160 to i16*), i32 %add, !dbg !140
  store i16 %or.i, i16* %arrayidx, align 2, !dbg !140, !tbaa !148
  %inc = add i32 %x.011, 1, !dbg !139
  tail call void @llvm.dbg.value(metadata !{i32 %inc}, i64 0, metadata !59), !dbg !139
  %exitcond = icmp eq i32 %inc, 80, !dbg !139
  br i1 %exitcond, label %for.inc5, label %for.body3, !dbg !139

for.inc5:                                         ; preds = %for.body3
  %inc6 = add i32 %y.012, 1, !dbg !137
  tail call void @llvm.dbg.value(metadata !{i32 %inc6}, i64 0, metadata !57), !dbg !137
  %exitcond13 = icmp eq i32 %inc6, 25, !dbg !137
  br i1 %exitcond13, label %for.end7, label %for.cond1.preheader, !dbg !137

for.end7:                                         ; preds = %for.inc5
  ret void, !dbg !150
}

; Function Attrs: nounwind
define void @terminal_setcolor(i8 zeroext %color) #2 {
entry:
  tail call void @llvm.dbg.value(metadata !{i8 %color}, i64 0, metadata !69), !dbg !151
  store i8 %color, i8* @terminal_color, align 1, !dbg !152, !tbaa !120
  ret void, !dbg !153
}

; Function Attrs: nounwind
define void @terminal_putentryat(i8 signext %c, i8 zeroext %color, i32 %x, i32 %y) #2 {
entry:
  tail call void @llvm.dbg.value(metadata !{i8 %c}, i64 0, metadata !74), !dbg !154
  tail call void @llvm.dbg.value(metadata !{i8 %color}, i64 0, metadata !75), !dbg !154
  tail call void @llvm.dbg.value(metadata !{i32 %x}, i64 0, metadata !76), !dbg !154
  tail call void @llvm.dbg.value(metadata !{i32 %y}, i64 0, metadata !77), !dbg !154
  %mul = mul i32 %y, 80, !dbg !155
  %add = add i32 %mul, %x, !dbg !155
  tail call void @llvm.dbg.value(metadata !{i32 %add}, i64 0, metadata !78), !dbg !155
  tail call void @llvm.dbg.value(metadata !{i8 %c}, i64 0, metadata !156), !dbg !158
  tail call void @llvm.dbg.value(metadata !{i8 %color}, i64 0, metadata !159), !dbg !158
  %conv.i = sext i8 %c to i16, !dbg !160
  tail call void @llvm.dbg.value(metadata !{i8 %c}, i64 0, metadata !161), !dbg !160
  %conv3.i = zext i8 %color to i16, !dbg !162
  %shl.i = shl nuw i16 %conv3.i, 8, !dbg !162
  %or.i = or i16 %shl.i, %conv.i, !dbg !162
  %0 = load i16** @terminal_buffer, align 4, !dbg !157, !tbaa !135
  %arrayidx = getelementptr inbounds i16* %0, i32 %add, !dbg !157
  store i16 %or.i, i16* %arrayidx, align 2, !dbg !157, !tbaa !148
  ret void, !dbg !163
}

; Function Attrs: nounwind
define zeroext i1 @terminal_handlewhitespace(i8 signext %c) #2 {
entry:
  tail call void @llvm.dbg.value(metadata !{i8 %c}, i64 0, metadata !84), !dbg !164
  %conv = sext i8 %c to i32, !dbg !165
  switch i32 %conv, label %return [
    i32 10, label %sw.bb
    i32 13, label %sw.bb1
    i32 9, label %sw.bb2
  ], !dbg !165

sw.bb:                                            ; preds = %entry
  %0 = load i32* @terminal_row, align 4, !dbg !166, !tbaa !126
  %add = add i32 %0, 1, !dbg !166
  store i32 %add, i32* @terminal_row, align 4, !dbg !166, !tbaa !126
  br label %return, !dbg !168

sw.bb1:                                           ; preds = %entry
  store i32 0, i32* @terminal_column, align 4, !dbg !169, !tbaa !126
  br label %return, !dbg !170

sw.bb2:                                           ; preds = %entry
  %1 = load i32* @terminal_column, align 4, !dbg !171, !tbaa !126
  %add3 = add i32 %1, 5, !dbg !171
  store i32 %add3, i32* @terminal_column, align 4, !dbg !171, !tbaa !126
  br label %return, !dbg !172

return:                                           ; preds = %sw.bb, %sw.bb1, %sw.bb2, %entry
  %retval.0 = phi i1 [ false, %entry ], [ true, %sw.bb2 ], [ true, %sw.bb1 ], [ true, %sw.bb ]
  ret i1 %retval.0, !dbg !173
}

; Function Attrs: nounwind
define void @terminal_putchar(i8 signext %c) #2 {
entry:
  tail call void @llvm.dbg.value(metadata !{i8 %c}, i64 0, metadata !89), !dbg !174
  tail call void @llvm.dbg.value(metadata !{i8 %c}, i64 0, metadata !175), !dbg !178
  %conv.i = sext i8 %c to i32, !dbg !179
  switch i32 %conv.i, label %if.end [
    i32 10, label %sw.bb.i
    i32 13, label %sw.bb1.i
    i32 9, label %sw.bb2.i
  ], !dbg !179

sw.bb.i:                                          ; preds = %entry
  %0 = load i32* @terminal_row, align 4, !dbg !180, !tbaa !126
  %add.i = add i32 %0, 1, !dbg !180
  store i32 %add.i, i32* @terminal_row, align 4, !dbg !180, !tbaa !126
  br label %if.end6, !dbg !181

sw.bb1.i:                                         ; preds = %entry
  store i32 0, i32* @terminal_column, align 4, !dbg !182, !tbaa !126
  br label %if.end6, !dbg !183

sw.bb2.i:                                         ; preds = %entry
  %1 = load i32* @terminal_column, align 4, !dbg !184, !tbaa !126
  %add3.i = add i32 %1, 5, !dbg !184
  store i32 %add3.i, i32* @terminal_column, align 4, !dbg !184, !tbaa !126
  br label %if.end6, !dbg !185

if.end:                                           ; preds = %entry
  %2 = load i8* @terminal_color, align 1, !dbg !186, !tbaa !120
  %3 = load i32* @terminal_column, align 4, !dbg !186, !tbaa !126
  %4 = load i32* @terminal_row, align 4, !dbg !186, !tbaa !126
  tail call void @llvm.dbg.value(metadata !{i8 %c}, i64 0, metadata !187), !dbg !188
  tail call void @llvm.dbg.value(metadata !{i8 %2}, i64 0, metadata !189), !dbg !188
  tail call void @llvm.dbg.value(metadata !{i32 %3}, i64 0, metadata !190), !dbg !188
  tail call void @llvm.dbg.value(metadata !{i32 %4}, i64 0, metadata !191), !dbg !188
  %mul.i = mul i32 %4, 80, !dbg !192
  %add.i8 = add i32 %mul.i, %3, !dbg !192
  tail call void @llvm.dbg.value(metadata !{i32 %add.i8}, i64 0, metadata !193), !dbg !192
  tail call void @llvm.dbg.value(metadata !{i8 %c}, i64 0, metadata !194), !dbg !196
  tail call void @llvm.dbg.value(metadata !{i8 %2}, i64 0, metadata !197), !dbg !196
  %conv.i.i = sext i8 %c to i16, !dbg !198
  tail call void @llvm.dbg.value(metadata !{i8 %c}, i64 0, metadata !199), !dbg !198
  %conv3.i.i = zext i8 %2 to i16, !dbg !200
  %shl.i.i = shl nuw i16 %conv3.i.i, 8, !dbg !200
  %or.i.i = or i16 %shl.i.i, %conv.i.i, !dbg !200
  %5 = load i16** @terminal_buffer, align 4, !dbg !195, !tbaa !135
  %arrayidx.i = getelementptr inbounds i16* %5, i32 %add.i8, !dbg !195
  store i16 %or.i.i, i16* %arrayidx.i, align 2, !dbg !195, !tbaa !148
  %inc = add i32 %3, 1, !dbg !201
  store i32 %inc, i32* @terminal_column, align 4, !dbg !201, !tbaa !126
  %cmp = icmp eq i32 %inc, 80, !dbg !201
  br i1 %cmp, label %if.then1, label %if.end6, !dbg !201

if.then1:                                         ; preds = %if.end
  store i32 0, i32* @terminal_column, align 4, !dbg !203, !tbaa !126
  %inc2 = add i32 %4, 1, !dbg !205
  %cmp3 = icmp eq i32 %inc2, 25, !dbg !205
  %.inc2 = select i1 %cmp3, i32 0, i32 %inc2, !dbg !205
  store i32 %.inc2, i32* @terminal_row, align 4, !dbg !207, !tbaa !126
  br label %if.end6, !dbg !209

if.end6:                                          ; preds = %sw.bb.i, %sw.bb1.i, %sw.bb2.i, %if.then1, %if.end
  ret void, !dbg !210
}

; Function Attrs: nounwind
define void @terminal_writestring(i8* nocapture readonly %data) #2 {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %data}, i64 0, metadata !94), !dbg !211
  tail call void @llvm.dbg.value(metadata !{i8* %data}, i64 0, metadata !212), !dbg !214
  tail call void @llvm.dbg.value(metadata !21, i64 0, metadata !215), !dbg !216
  br label %while.cond.i, !dbg !217

while.cond.i:                                     ; preds = %while.cond.i, %entry
  %indvars.iv = phi i32 [ %indvars.iv.next, %while.cond.i ], [ 0, %entry ]
  %arrayidx.i = getelementptr inbounds i8* %data, i32 %indvars.iv, !dbg !217
  %0 = load i8* %arrayidx.i, align 1, !dbg !217, !tbaa !120
  %cmp.i = icmp eq i8 %0, 0, !dbg !217
  %indvars.iv.next = add i32 %indvars.iv, 1, !dbg !217
  tail call void @llvm.dbg.value(metadata !{i32 %indvars.iv.next}, i64 0, metadata !215), !dbg !218
  br i1 %cmp.i, label %for.cond.preheader, label %while.cond.i, !dbg !217

for.cond.preheader:                               ; preds = %while.cond.i
  %cmp6 = icmp eq i32 %indvars.iv, 0, !dbg !219
  br i1 %cmp6, label %for.end, label %for.body, !dbg !219

for.body:                                         ; preds = %for.cond.preheader, %terminal_putchar.exit
  %i.07 = phi i32 [ %inc, %terminal_putchar.exit ], [ 0, %for.cond.preheader ]
  %arrayidx = getelementptr inbounds i8* %data, i32 %i.07, !dbg !220
  %1 = load i8* %arrayidx, align 1, !dbg !220, !tbaa !120
  tail call void @llvm.dbg.value(metadata !{i8 %1}, i64 0, metadata !221), !dbg !222
  tail call void @llvm.dbg.value(metadata !{i8 %1}, i64 0, metadata !223), !dbg !225
  %conv.i.i = sext i8 %1 to i32, !dbg !226
  switch i32 %conv.i.i, label %if.end.i [
    i32 10, label %sw.bb.i.i
    i32 13, label %sw.bb1.i.i
    i32 9, label %sw.bb2.i.i
  ], !dbg !226

sw.bb.i.i:                                        ; preds = %for.body
  %2 = load i32* @terminal_row, align 4, !dbg !227, !tbaa !126
  %add.i.i = add i32 %2, 1, !dbg !227
  store i32 %add.i.i, i32* @terminal_row, align 4, !dbg !227, !tbaa !126
  br label %terminal_putchar.exit, !dbg !228

sw.bb1.i.i:                                       ; preds = %for.body
  store i32 0, i32* @terminal_column, align 4, !dbg !229, !tbaa !126
  br label %terminal_putchar.exit, !dbg !230

sw.bb2.i.i:                                       ; preds = %for.body
  %3 = load i32* @terminal_column, align 4, !dbg !231, !tbaa !126
  %add3.i.i = add i32 %3, 5, !dbg !231
  store i32 %add3.i.i, i32* @terminal_column, align 4, !dbg !231, !tbaa !126
  br label %terminal_putchar.exit, !dbg !232

if.end.i:                                         ; preds = %for.body
  %4 = load i8* @terminal_color, align 1, !dbg !233, !tbaa !120
  %5 = load i32* @terminal_column, align 4, !dbg !233, !tbaa !126
  %6 = load i32* @terminal_row, align 4, !dbg !233, !tbaa !126
  tail call void @llvm.dbg.value(metadata !{i8 %1}, i64 0, metadata !234), !dbg !235
  tail call void @llvm.dbg.value(metadata !{i8 %4}, i64 0, metadata !236), !dbg !235
  tail call void @llvm.dbg.value(metadata !{i32 %5}, i64 0, metadata !237), !dbg !235
  tail call void @llvm.dbg.value(metadata !{i32 %6}, i64 0, metadata !238), !dbg !235
  %mul.i.i = mul i32 %6, 80, !dbg !239
  %add.i8.i = add i32 %mul.i.i, %5, !dbg !239
  tail call void @llvm.dbg.value(metadata !{i32 %add.i8.i}, i64 0, metadata !240), !dbg !239
  tail call void @llvm.dbg.value(metadata !{i8 %1}, i64 0, metadata !241), !dbg !243
  tail call void @llvm.dbg.value(metadata !{i8 %4}, i64 0, metadata !244), !dbg !243
  %conv.i.i.i = sext i8 %1 to i16, !dbg !245
  tail call void @llvm.dbg.value(metadata !{i8 %1}, i64 0, metadata !246), !dbg !245
  %conv3.i.i.i = zext i8 %4 to i16, !dbg !247
  %shl.i.i.i = shl nuw i16 %conv3.i.i.i, 8, !dbg !247
  %or.i.i.i = or i16 %shl.i.i.i, %conv.i.i.i, !dbg !247
  %7 = load i16** @terminal_buffer, align 4, !dbg !242, !tbaa !135
  %arrayidx.i.i = getelementptr inbounds i16* %7, i32 %add.i8.i, !dbg !242
  store i16 %or.i.i.i, i16* %arrayidx.i.i, align 2, !dbg !242, !tbaa !148
  %inc.i4 = add i32 %5, 1, !dbg !248
  store i32 %inc.i4, i32* @terminal_column, align 4, !dbg !248, !tbaa !126
  %cmp.i5 = icmp eq i32 %inc.i4, 80, !dbg !248
  br i1 %cmp.i5, label %if.then1.i, label %terminal_putchar.exit, !dbg !248

if.then1.i:                                       ; preds = %if.end.i
  store i32 0, i32* @terminal_column, align 4, !dbg !249, !tbaa !126
  %inc2.i = add i32 %6, 1, !dbg !250
  %cmp3.i = icmp eq i32 %inc2.i, 25, !dbg !250
  %.inc2.i = select i1 %cmp3.i, i32 0, i32 %inc2.i, !dbg !250
  store i32 %.inc2.i, i32* @terminal_row, align 4, !dbg !251, !tbaa !126
  br label %terminal_putchar.exit, !dbg !252

terminal_putchar.exit:                            ; preds = %sw.bb.i.i, %sw.bb1.i.i, %sw.bb2.i.i, %if.end.i, %if.then1.i
  %inc = add i32 %i.07, 1, !dbg !219
  tail call void @llvm.dbg.value(metadata !{i32 %inc}, i64 0, metadata !96), !dbg !219
  %exitcond = icmp eq i32 %inc, %indvars.iv, !dbg !219
  br i1 %exitcond, label %for.end, label %for.body, !dbg !219

for.end:                                          ; preds = %terminal_putchar.exit, %for.cond.preheader
  ret void, !dbg !253
}

; Function Attrs: nounwind
define void @kernel_main() #2 {
entry:
  store i32 0, i32* @terminal_row, align 4, !dbg !254, !tbaa !126
  store i32 0, i32* @terminal_column, align 4, !dbg !256, !tbaa !126
  tail call void @llvm.dbg.value(metadata !129, i64 0, metadata !257), !dbg !259
  tail call void @llvm.dbg.value(metadata !21, i64 0, metadata !260), !dbg !259
  store i8 7, i8* @terminal_color, align 1, !dbg !258, !tbaa !120
  store i16* inttoptr (i32 -1072988160 to i16*), i16** @terminal_buffer, align 4, !dbg !261, !tbaa !135
  tail call void @llvm.dbg.value(metadata !21, i64 0, metadata !262), !dbg !263
  br label %for.cond1.preheader.i, !dbg !263

for.cond1.preheader.i:                            ; preds = %for.inc5.i, %entry
  %y.012.i = phi i32 [ 0, %entry ], [ %inc6.i, %for.inc5.i ]
  %mul.i = mul i32 %y.012.i, 80, !dbg !264
  br label %for.body3.i, !dbg !265

for.body3.i:                                      ; preds = %for.body3.i, %for.cond1.preheader.i
  %x.011.i = phi i32 [ 0, %for.cond1.preheader.i ], [ %inc.i, %for.body3.i ]
  %add.i = add i32 %x.011.i, %mul.i, !dbg !264
  tail call void @llvm.dbg.value(metadata !{i32 %add.i}, i64 0, metadata !266), !dbg !264
  %0 = load i8* @terminal_color, align 1, !dbg !267, !tbaa !120
  tail call void @llvm.dbg.value(metadata !141, i64 0, metadata !268), !dbg !269
  tail call void @llvm.dbg.value(metadata !{i8 %0}, i64 0, metadata !270), !dbg !269
  tail call void @llvm.dbg.value(metadata !141, i64 0, metadata !271), !dbg !272
  %conv3.i.i = zext i8 %0 to i16, !dbg !273
  %shl.i.i = shl nuw i16 %conv3.i.i, 8, !dbg !273
  %or.i.i = or i16 %shl.i.i, 32, !dbg !273
  %arrayidx.i = getelementptr inbounds i16* inttoptr (i32 -1072988160 to i16*), i32 %add.i, !dbg !267
  store i16 %or.i.i, i16* %arrayidx.i, align 2, !dbg !267, !tbaa !148
  %inc.i = add i32 %x.011.i, 1, !dbg !265
  tail call void @llvm.dbg.value(metadata !{i32 %inc.i}, i64 0, metadata !274), !dbg !265
  %exitcond.i = icmp eq i32 %inc.i, 80, !dbg !265
  br i1 %exitcond.i, label %for.inc5.i, label %for.body3.i, !dbg !265

for.inc5.i:                                       ; preds = %for.body3.i
  %inc6.i = add i32 %y.012.i, 1, !dbg !263
  tail call void @llvm.dbg.value(metadata !{i32 %inc6.i}, i64 0, metadata !262), !dbg !263
  %exitcond13.i = icmp eq i32 %inc6.i, 25, !dbg !263
  br i1 %exitcond13.i, label %for.body.i, label %for.cond1.preheader.i, !dbg !263

for.body.i:                                       ; preds = %for.inc5.i, %terminal_putchar.exit.i
  %1 = phi i32 [ %5, %terminal_putchar.exit.i ], [ 0, %for.inc5.i ]
  %2 = phi i32 [ %6, %terminal_putchar.exit.i ], [ 0, %for.inc5.i ]
  %i.07.i = phi i32 [ %inc.i2, %terminal_putchar.exit.i ], [ 0, %for.inc5.i ]
  %arrayidx.i1 = getelementptr inbounds [22 x i8]* @.str, i32 0, i32 %i.07.i, !dbg !275
  %3 = load i8* %arrayidx.i1, align 1, !dbg !275, !tbaa !120
  tail call void @llvm.dbg.value(metadata !{i8 %3}, i64 0, metadata !277), !dbg !278
  tail call void @llvm.dbg.value(metadata !{i8 %3}, i64 0, metadata !279), !dbg !281
  %conv.i.i.i = sext i8 %3 to i32, !dbg !282
  switch i32 %conv.i.i.i, label %if.end.i.i [
    i32 10, label %sw.bb.i.i.i
    i32 13, label %sw.bb1.i.i.i
    i32 9, label %sw.bb2.i.i.i
  ], !dbg !282

sw.bb.i.i.i:                                      ; preds = %for.body.i
  %add.i.i.i = add i32 %1, 1, !dbg !283
  store i32 %add.i.i.i, i32* @terminal_row, align 4, !dbg !283, !tbaa !126
  br label %terminal_putchar.exit.i, !dbg !284

sw.bb1.i.i.i:                                     ; preds = %for.body.i
  store i32 0, i32* @terminal_column, align 4, !dbg !285, !tbaa !126
  br label %terminal_putchar.exit.i, !dbg !286

sw.bb2.i.i.i:                                     ; preds = %for.body.i
  %add3.i.i.i = add i32 %2, 5, !dbg !287
  store i32 %add3.i.i.i, i32* @terminal_column, align 4, !dbg !287, !tbaa !126
  br label %terminal_putchar.exit.i, !dbg !288

if.end.i.i:                                       ; preds = %for.body.i
  %4 = load i8* @terminal_color, align 1, !dbg !289, !tbaa !120
  tail call void @llvm.dbg.value(metadata !{i8 %3}, i64 0, metadata !290), !dbg !291
  tail call void @llvm.dbg.value(metadata !{i8 %4}, i64 0, metadata !292), !dbg !291
  tail call void @llvm.dbg.value(metadata !{i32 %2}, i64 0, metadata !293), !dbg !291
  tail call void @llvm.dbg.value(metadata !{i32 %1}, i64 0, metadata !294), !dbg !291
  %mul.i.i.i = mul i32 %1, 80, !dbg !295
  %add.i8.i.i = add i32 %mul.i.i.i, %2, !dbg !295
  tail call void @llvm.dbg.value(metadata !{i32 %add.i8.i.i}, i64 0, metadata !296), !dbg !295
  tail call void @llvm.dbg.value(metadata !{i8 %3}, i64 0, metadata !297), !dbg !299
  tail call void @llvm.dbg.value(metadata !{i8 %4}, i64 0, metadata !300), !dbg !299
  %conv.i.i.i.i = sext i8 %3 to i16, !dbg !301
  tail call void @llvm.dbg.value(metadata !{i8 %3}, i64 0, metadata !302), !dbg !301
  %conv3.i.i.i.i = zext i8 %4 to i16, !dbg !303
  %shl.i.i.i.i = shl nuw i16 %conv3.i.i.i.i, 8, !dbg !303
  %or.i.i.i.i = or i16 %shl.i.i.i.i, %conv.i.i.i.i, !dbg !303
  %arrayidx.i.i.i = getelementptr inbounds i16* inttoptr (i32 -1072988160 to i16*), i32 %add.i8.i.i, !dbg !298
  store i16 %or.i.i.i.i, i16* %arrayidx.i.i.i, align 2, !dbg !298, !tbaa !148
  %inc.i4.i = add i32 %2, 1, !dbg !304
  store i32 %inc.i4.i, i32* @terminal_column, align 4, !dbg !304, !tbaa !126
  %cmp.i5.i = icmp eq i32 %inc.i4.i, 80, !dbg !304
  br i1 %cmp.i5.i, label %if.then1.i.i, label %terminal_putchar.exit.i, !dbg !304

if.then1.i.i:                                     ; preds = %if.end.i.i
  store i32 0, i32* @terminal_column, align 4, !dbg !305, !tbaa !126
  %inc2.i.i = add i32 %1, 1, !dbg !306
  %cmp3.i.i = icmp eq i32 %inc2.i.i, 25, !dbg !306
  %.inc2.i.i = select i1 %cmp3.i.i, i32 0, i32 %inc2.i.i, !dbg !306
  store i32 %.inc2.i.i, i32* @terminal_row, align 4, !dbg !307, !tbaa !126
  br label %terminal_putchar.exit.i, !dbg !308

terminal_putchar.exit.i:                          ; preds = %if.then1.i.i, %if.end.i.i, %sw.bb2.i.i.i, %sw.bb1.i.i.i, %sw.bb.i.i.i
  %5 = phi i32 [ %.inc2.i.i, %if.then1.i.i ], [ %1, %if.end.i.i ], [ %1, %sw.bb2.i.i.i ], [ %1, %sw.bb1.i.i.i ], [ %add.i.i.i, %sw.bb.i.i.i ]
  %6 = phi i32 [ 0, %if.then1.i.i ], [ %inc.i4.i, %if.end.i.i ], [ %add3.i.i.i, %sw.bb2.i.i.i ], [ 0, %sw.bb1.i.i.i ], [ %2, %sw.bb.i.i.i ]
  %inc.i2 = add i32 %i.07.i, 1, !dbg !309
  tail call void @llvm.dbg.value(metadata !{i32 %inc.i2}, i64 0, metadata !310), !dbg !309
  %exitcond.i3 = icmp eq i32 %inc.i2, 21, !dbg !309
  br i1 %exitcond.i3, label %terminal_writestring.exit, label %for.body.i, !dbg !309

terminal_writestring.exit:                        ; preds = %terminal_putchar.exit.i
  %call = tail call i32 bitcast (i32 (...)* @mmap to i32 (i32)*)(i32 1048576) #5, !dbg !311
  ret void, !dbg !312
}

declare i32 @mmap(...) #3

; Function Attrs: nounwind readnone
declare void @llvm.dbg.value(metadata, i64, metadata) #4

attributes #0 = { nounwind readnone "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readonly "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind readnone }
attributes #5 = { nobuiltin nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!110}
!llvm.ident = !{!111}

!0 = metadata !{i32 786449, metadata !1, i32 12, metadata !"clang version 3.4 (http://llvm.org/git/clang.git 82a2911a94947e20ac4fd961b6322adf74ad9224) (http://llvm.org/git/llvm.git 52244da7f2b3def646900520668b859343b84a33)", i1 true, metadata !"", i32 0, metadata !2, metadata !21, metadata !22, metadata !102, metadata !21, metadata !""} ; [ DW_TAG_compile_unit ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/kernel.c] [DW_LANG_C99]
!1 = metadata !{metadata !"src/kernel.c", metadata !"/home/gbps/Desktop/Projects/os_notshared/pandos"}
!2 = metadata !{metadata !3}
!3 = metadata !{i32 786436, metadata !1, null, metadata !"vga_color", i32 19, i64 32, i64 32, i32 0, i32 0, null, metadata !4, i32 0, null, null, null} ; [ DW_TAG_enumeration_type ] [vga_color] [line 19, size 32, align 32, offset 0] [def] [from ]
!4 = metadata !{metadata !5, metadata !6, metadata !7, metadata !8, metadata !9, metadata !10, metadata !11, metadata !12, metadata !13, metadata !14, metadata !15, metadata !16, metadata !17, metadata !18, metadata !19, metadata !20}
!5 = metadata !{i32 786472, metadata !"COLOR_BLACK", i64 0} ; [ DW_TAG_enumerator ] [COLOR_BLACK :: 0]
!6 = metadata !{i32 786472, metadata !"COLOR_BLUE", i64 1} ; [ DW_TAG_enumerator ] [COLOR_BLUE :: 1]
!7 = metadata !{i32 786472, metadata !"COLOR_GREEN", i64 2} ; [ DW_TAG_enumerator ] [COLOR_GREEN :: 2]
!8 = metadata !{i32 786472, metadata !"COLOR_CYAN", i64 3} ; [ DW_TAG_enumerator ] [COLOR_CYAN :: 3]
!9 = metadata !{i32 786472, metadata !"COLOR_RED", i64 4} ; [ DW_TAG_enumerator ] [COLOR_RED :: 4]
!10 = metadata !{i32 786472, metadata !"COLOR_MAGENTA", i64 5} ; [ DW_TAG_enumerator ] [COLOR_MAGENTA :: 5]
!11 = metadata !{i32 786472, metadata !"COLOR_BROWN", i64 6} ; [ DW_TAG_enumerator ] [COLOR_BROWN :: 6]
!12 = metadata !{i32 786472, metadata !"COLOR_LIGHT_GREY", i64 7} ; [ DW_TAG_enumerator ] [COLOR_LIGHT_GREY :: 7]
!13 = metadata !{i32 786472, metadata !"COLOR_DARK_GREY", i64 8} ; [ DW_TAG_enumerator ] [COLOR_DARK_GREY :: 8]
!14 = metadata !{i32 786472, metadata !"COLOR_LIGHT_BLUE", i64 9} ; [ DW_TAG_enumerator ] [COLOR_LIGHT_BLUE :: 9]
!15 = metadata !{i32 786472, metadata !"COLOR_LIGHT_GREEN", i64 10} ; [ DW_TAG_enumerator ] [COLOR_LIGHT_GREEN :: 10]
!16 = metadata !{i32 786472, metadata !"COLOR_LIGHT_CYAN", i64 11} ; [ DW_TAG_enumerator ] [COLOR_LIGHT_CYAN :: 11]
!17 = metadata !{i32 786472, metadata !"COLOR_LIGHT_RED", i64 12} ; [ DW_TAG_enumerator ] [COLOR_LIGHT_RED :: 12]
!18 = metadata !{i32 786472, metadata !"COLOR_LIGHT_MAGENTA", i64 13} ; [ DW_TAG_enumerator ] [COLOR_LIGHT_MAGENTA :: 13]
!19 = metadata !{i32 786472, metadata !"COLOR_LIGHT_BROWN", i64 14} ; [ DW_TAG_enumerator ] [COLOR_LIGHT_BROWN :: 14]
!20 = metadata !{i32 786472, metadata !"COLOR_WHITE", i64 15} ; [ DW_TAG_enumerator ] [COLOR_WHITE :: 15]
!21 = metadata !{i32 0}
!22 = metadata !{metadata !23, metadata !32, metadata !43, metadata !53, metadata !65, metadata !70, metadata !79, metadata !85, metadata !90, metadata !98}
!23 = metadata !{i32 786478, metadata !1, metadata !24, metadata !"make_color", metadata !"make_color", metadata !"", i32 38, metadata !25, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i8 (i32, i32)* @make_color, null, null, metadata !29, i32 38} ; [ DW_TAG_subprogram ] [line 38] [def] [make_color]
!24 = metadata !{i32 786473, metadata !1}         ; [ DW_TAG_file_type ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/kernel.c]
!25 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !26, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!26 = metadata !{metadata !27, metadata !3, metadata !3}
!27 = metadata !{i32 786454, metadata !1, null, metadata !"uint8_t", i32 238, i64 0, i64 0, i64 0, i32 0, metadata !28} ; [ DW_TAG_typedef ] [uint8_t] [line 238, size 0, align 0, offset 0] [from unsigned char]
!28 = metadata !{i32 786468, null, null, metadata !"unsigned char", i32 0, i64 8, i64 8, i64 0, i32 0, i32 8} ; [ DW_TAG_base_type ] [unsigned char] [line 0, size 8, align 8, offset 0, enc DW_ATE_unsigned_char]
!29 = metadata !{metadata !30, metadata !31}
!30 = metadata !{i32 786689, metadata !23, metadata !"fg", metadata !24, i32 16777254, metadata !3, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [fg] [line 38]
!31 = metadata !{i32 786689, metadata !23, metadata !"bg", metadata !24, i32 33554470, metadata !3, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [bg] [line 38]
!32 = metadata !{i32 786478, metadata !1, metadata !24, metadata !"make_vgaentry", metadata !"make_vgaentry", metadata !"", i32 42, metadata !33, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i16 (i8, i8)* @make_vgaentry, null, null, metadata !38, i32 42} ; [ DW_TAG_subprogram ] [line 42] [def] [make_vgaentry]
!33 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !34, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!34 = metadata !{metadata !35, metadata !37, metadata !27}
!35 = metadata !{i32 786454, metadata !1, null, metadata !"uint16_t", i32 219, i64 0, i64 0, i64 0, i32 0, metadata !36} ; [ DW_TAG_typedef ] [uint16_t] [line 219, size 0, align 0, offset 0] [from unsigned short]
!36 = metadata !{i32 786468, null, null, metadata !"unsigned short", i32 0, i64 16, i64 16, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ] [unsigned short] [line 0, size 16, align 16, offset 0, enc DW_ATE_unsigned]
!37 = metadata !{i32 786468, null, null, metadata !"char", i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ] [char] [line 0, size 8, align 8, offset 0, enc DW_ATE_signed_char]
!38 = metadata !{metadata !39, metadata !40, metadata !41, metadata !42}
!39 = metadata !{i32 786689, metadata !32, metadata !"c", metadata !24, i32 16777258, metadata !37, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [c] [line 42]
!40 = metadata !{i32 786689, metadata !32, metadata !"color", metadata !24, i32 33554474, metadata !27, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [color] [line 42]
!41 = metadata !{i32 786688, metadata !32, metadata !"c16", metadata !24, i32 43, metadata !35, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [c16] [line 43]
!42 = metadata !{i32 786688, metadata !32, metadata !"color16", metadata !24, i32 44, metadata !35, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [color16] [line 44]
!43 = metadata !{i32 786478, metadata !1, metadata !24, metadata !"strlen", metadata !"strlen", metadata !"", i32 48, metadata !44, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*)* @strlen, null, null, metadata !50, i32 48} ; [ DW_TAG_subprogram ] [line 48] [def] [strlen]
!44 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !45, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!45 = metadata !{metadata !46, metadata !48}
!46 = metadata !{i32 786454, metadata !1, null, metadata !"size_t", i32 42, i64 0, i64 0, i64 0, i32 0, metadata !47} ; [ DW_TAG_typedef ] [size_t] [line 42, size 0, align 0, offset 0] [from unsigned int]
!47 = metadata !{i32 786468, null, null, metadata !"unsigned int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ] [unsigned int] [line 0, size 32, align 32, offset 0, enc DW_ATE_unsigned]
!48 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 32, i64 32, i64 0, i32 0, metadata !49} ; [ DW_TAG_pointer_type ] [line 0, size 32, align 32, offset 0] [from ]
!49 = metadata !{i32 786470, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, metadata !37} ; [ DW_TAG_const_type ] [line 0, size 0, align 0, offset 0] [from char]
!50 = metadata !{metadata !51, metadata !52}
!51 = metadata !{i32 786689, metadata !43, metadata !"str", metadata !24, i32 16777264, metadata !48, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [str] [line 48]
!52 = metadata !{i32 786688, metadata !43, metadata !"ret", metadata !24, i32 49, metadata !46, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [ret] [line 49]
!53 = metadata !{i32 786478, metadata !1, metadata !24, metadata !"terminal_initialize", metadata !"terminal_initialize", metadata !"", i32 63, metadata !54, i1 false, i1 true, i32 0, i32 0, null, i32 0, i1 true, void ()* @terminal_initialize, null, null, metadata !56, i32 63} ; [ DW_TAG_subprogram ] [line 63] [def] [terminal_initialize]
!54 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !55, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!55 = metadata !{null}
!56 = metadata !{metadata !57, metadata !59, metadata !62}
!57 = metadata !{i32 786688, metadata !58, metadata !"y", metadata !24, i32 68, metadata !46, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [y] [line 68]
!58 = metadata !{i32 786443, metadata !1, metadata !53, i32 68, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/kernel.c]
!59 = metadata !{i32 786688, metadata !60, metadata !"x", metadata !24, i32 69, metadata !46, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [x] [line 69]
!60 = metadata !{i32 786443, metadata !1, metadata !61, i32 69, i32 0, i32 2} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/kernel.c]
!61 = metadata !{i32 786443, metadata !1, metadata !58, i32 68, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/kernel.c]
!62 = metadata !{i32 786688, metadata !63, metadata !"index", metadata !24, i32 70, metadata !64, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [index] [line 70]
!63 = metadata !{i32 786443, metadata !1, metadata !60, i32 69, i32 0, i32 3} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/kernel.c]
!64 = metadata !{i32 786470, null, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, metadata !46} ; [ DW_TAG_const_type ] [line 0, size 0, align 0, offset 0] [from size_t]
!65 = metadata !{i32 786478, metadata !1, metadata !24, metadata !"terminal_setcolor", metadata !"terminal_setcolor", metadata !"", i32 76, metadata !66, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, void (i8)* @terminal_setcolor, null, null, metadata !68, i32 76} ; [ DW_TAG_subprogram ] [line 76] [def] [terminal_setcolor]
!66 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !67, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!67 = metadata !{null, metadata !27}
!68 = metadata !{metadata !69}
!69 = metadata !{i32 786689, metadata !65, metadata !"color", metadata !24, i32 16777292, metadata !27, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [color] [line 76]
!70 = metadata !{i32 786478, metadata !1, metadata !24, metadata !"terminal_putentryat", metadata !"terminal_putentryat", metadata !"", i32 80, metadata !71, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, void (i8, i8, i32, i32)* @terminal_putentryat, null, null, metadata !73, i32 80} ; [ DW_TAG_subprogram ] [line 80] [def] [terminal_putentryat]
!71 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !72, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!72 = metadata !{null, metadata !37, metadata !27, metadata !46, metadata !46}
!73 = metadata !{metadata !74, metadata !75, metadata !76, metadata !77, metadata !78}
!74 = metadata !{i32 786689, metadata !70, metadata !"c", metadata !24, i32 16777296, metadata !37, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [c] [line 80]
!75 = metadata !{i32 786689, metadata !70, metadata !"color", metadata !24, i32 33554512, metadata !27, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [color] [line 80]
!76 = metadata !{i32 786689, metadata !70, metadata !"x", metadata !24, i32 50331728, metadata !46, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [x] [line 80]
!77 = metadata !{i32 786689, metadata !70, metadata !"y", metadata !24, i32 67108944, metadata !46, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [y] [line 80]
!78 = metadata !{i32 786688, metadata !70, metadata !"index", metadata !24, i32 81, metadata !64, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [index] [line 81]
!79 = metadata !{i32 786478, metadata !1, metadata !24, metadata !"terminal_handlewhitespace", metadata !"terminal_handlewhitespace", metadata !"", i32 85, metadata !80, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i1 (i8)* @terminal_handlewhitespace, null, null, metadata !83, i32 86} ; [ DW_TAG_subprogram ] [line 85] [def] [scope 86] [terminal_handlewhitespace]
!80 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !81, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!81 = metadata !{metadata !82, metadata !37}
!82 = metadata !{i32 786468, null, null, metadata !"_Bool", i32 0, i64 8, i64 8, i64 0, i32 0, i32 2} ; [ DW_TAG_base_type ] [_Bool] [line 0, size 8, align 8, offset 0, enc DW_ATE_boolean]
!83 = metadata !{metadata !84}
!84 = metadata !{i32 786689, metadata !79, metadata !"c", metadata !24, i32 16777301, metadata !37, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [c] [line 85]
!85 = metadata !{i32 786478, metadata !1, metadata !24, metadata !"terminal_putchar", metadata !"terminal_putchar", metadata !"", i32 106, metadata !86, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, void (i8)* @terminal_putchar, null, null, metadata !88, i32 107} ; [ DW_TAG_subprogram ] [line 106] [def] [scope 107] [terminal_putchar]
!86 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !87, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!87 = metadata !{null, metadata !37}
!88 = metadata !{metadata !89}
!89 = metadata !{i32 786689, metadata !85, metadata !"c", metadata !24, i32 16777322, metadata !37, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [c] [line 106]
!90 = metadata !{i32 786478, metadata !1, metadata !24, metadata !"terminal_writestring", metadata !"terminal_writestring", metadata !"", i32 121, metadata !91, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, void (i8*)* @terminal_writestring, null, null, metadata !93, i32 121} ; [ DW_TAG_subprogram ] [line 121] [def] [terminal_writestring]
!91 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !92, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!92 = metadata !{null, metadata !48}
!93 = metadata !{metadata !94, metadata !95, metadata !96}
!94 = metadata !{i32 786689, metadata !90, metadata !"data", metadata !24, i32 16777337, metadata !48, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [data] [line 121]
!95 = metadata !{i32 786688, metadata !90, metadata !"datalen", metadata !24, i32 122, metadata !46, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [datalen] [line 122]
!96 = metadata !{i32 786688, metadata !97, metadata !"i", metadata !24, i32 123, metadata !46, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 123]
!97 = metadata !{i32 786443, metadata !1, metadata !90, i32 123, i32 0, i32 11} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/kernel.c]
!98 = metadata !{i32 786478, metadata !1, metadata !24, metadata !"kernel_main", metadata !"kernel_main", metadata !"", i32 130, metadata !54, i1 false, i1 true, i32 0, i32 0, null, i32 0, i1 true, void ()* @kernel_main, null, null, metadata !99, i32 130} ; [ DW_TAG_subprogram ] [line 130] [def] [kernel_main]
!99 = metadata !{metadata !100}
!100 = metadata !{i32 786688, metadata !98, metadata !"test_page", metadata !24, i32 140, metadata !101, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [test_page] [line 140]
!101 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 32, i64 32, i64 0, i32 0, null} ; [ DW_TAG_pointer_type ] [line 0, size 32, align 32, offset 0] [from ]
!102 = metadata !{metadata !103, metadata !104, metadata !104, metadata !104, metadata !104, metadata !103, metadata !105, metadata !106, metadata !107, metadata !108}
!103 = metadata !{i32 786484, i32 0, metadata !24, metadata !"VGA_HEIGHT", metadata !"VGA_HEIGHT", metadata !"VGA_HEIGHT", metadata !24, i32 56, metadata !64, i32 1, i32 1, i32 25, null} ; [ DW_TAG_variable ] [VGA_HEIGHT] [line 56] [local] [def]
!104 = metadata !{i32 786484, i32 0, metadata !24, metadata !"VGA_WIDTH", metadata !"VGA_WIDTH", metadata !"VGA_WIDTH", metadata !24, i32 55, metadata !64, i32 1, i32 1, i32 80, null} ; [ DW_TAG_variable ] [VGA_WIDTH] [line 55] [local] [def]
!105 = metadata !{i32 786484, i32 0, null, metadata !"terminal_row", metadata !"terminal_row", metadata !"", metadata !24, i32 58, metadata !46, i32 0, i32 1, i32* @terminal_row, null} ; [ DW_TAG_variable ] [terminal_row] [line 58] [def]
!106 = metadata !{i32 786484, i32 0, null, metadata !"terminal_column", metadata !"terminal_column", metadata !"", metadata !24, i32 59, metadata !46, i32 0, i32 1, i32* @terminal_column, null} ; [ DW_TAG_variable ] [terminal_column] [line 59] [def]
!107 = metadata !{i32 786484, i32 0, null, metadata !"terminal_color", metadata !"terminal_color", metadata !"", metadata !24, i32 60, metadata !27, i32 0, i32 1, i8* @terminal_color, null} ; [ DW_TAG_variable ] [terminal_color] [line 60] [def]
!108 = metadata !{i32 786484, i32 0, null, metadata !"terminal_buffer", metadata !"terminal_buffer", metadata !"", metadata !24, i32 61, metadata !109, i32 0, i32 1, i16** @terminal_buffer, null} ; [ DW_TAG_variable ] [terminal_buffer] [line 61] [def]
!109 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 32, i64 32, i64 0, i32 0, metadata !35} ; [ DW_TAG_pointer_type ] [line 0, size 32, align 32, offset 0] [from uint16_t]
!110 = metadata !{i32 2, metadata !"Dwarf Version", i32 4}
!111 = metadata !{metadata !"clang version 3.4 (http://llvm.org/git/clang.git 82a2911a94947e20ac4fd961b6322adf74ad9224) (http://llvm.org/git/llvm.git 52244da7f2b3def646900520668b859343b84a33)"}
!112 = metadata !{i32 38, i32 0, metadata !23, null}
!113 = metadata !{i32 39, i32 0, metadata !23, null}
!114 = metadata !{i32 42, i32 0, metadata !32, null}
!115 = metadata !{i32 43, i32 0, metadata !32, null}
!116 = metadata !{i32 45, i32 0, metadata !32, null}
!117 = metadata !{i32 48, i32 0, metadata !43, null}
!118 = metadata !{i32 49, i32 0, metadata !43, null}
!119 = metadata !{i32 50, i32 0, metadata !43, null}
!120 = metadata !{metadata !121, metadata !121, i64 0}
!121 = metadata !{metadata !"omnipotent char", metadata !122, i64 0}
!122 = metadata !{metadata !"Simple C/C++ TBAA"}
!123 = metadata !{i32 51, i32 0, metadata !43, null}
!124 = metadata !{i32 52, i32 0, metadata !43, null}
!125 = metadata !{i32 64, i32 0, metadata !53, null}
!126 = metadata !{metadata !127, metadata !127, i64 0}
!127 = metadata !{metadata !"int", metadata !121, i64 0}
!128 = metadata !{i32 65, i32 0, metadata !53, null}
!129 = metadata !{i32 7}
!130 = metadata !{i32 786689, metadata !23, metadata !"fg", metadata !24, i32 16777254, metadata !3, i32 0, metadata !131} ; [ DW_TAG_arg_variable ] [fg] [line 38]
!131 = metadata !{i32 66, i32 0, metadata !53, null}
!132 = metadata !{i32 38, i32 0, metadata !23, metadata !131}
!133 = metadata !{i32 786689, metadata !23, metadata !"bg", metadata !24, i32 33554470, metadata !3, i32 0, metadata !131} ; [ DW_TAG_arg_variable ] [bg] [line 38]
!134 = metadata !{i32 67, i32 0, metadata !53, null}
!135 = metadata !{metadata !136, metadata !136, i64 0}
!136 = metadata !{metadata !"any pointer", metadata !121, i64 0}
!137 = metadata !{i32 68, i32 0, metadata !58, null}
!138 = metadata !{i32 70, i32 0, metadata !63, null}
!139 = metadata !{i32 69, i32 0, metadata !60, null}
!140 = metadata !{i32 71, i32 0, metadata !63, null}
!141 = metadata !{i8 32}
!142 = metadata !{i32 786689, metadata !32, metadata !"c", metadata !24, i32 16777258, metadata !37, i32 0, metadata !140} ; [ DW_TAG_arg_variable ] [c] [line 42]
!143 = metadata !{i32 42, i32 0, metadata !32, metadata !140}
!144 = metadata !{i32 786689, metadata !32, metadata !"color", metadata !24, i32 33554474, metadata !27, i32 0, metadata !140} ; [ DW_TAG_arg_variable ] [color] [line 42]
!145 = metadata !{i32 786688, metadata !32, metadata !"c16", metadata !24, i32 43, metadata !35, i32 0, metadata !140} ; [ DW_TAG_auto_variable ] [c16] [line 43]
!146 = metadata !{i32 43, i32 0, metadata !32, metadata !140}
!147 = metadata !{i32 45, i32 0, metadata !32, metadata !140}
!148 = metadata !{metadata !149, metadata !149, i64 0}
!149 = metadata !{metadata !"short", metadata !121, i64 0}
!150 = metadata !{i32 74, i32 0, metadata !53, null}
!151 = metadata !{i32 76, i32 0, metadata !65, null}
!152 = metadata !{i32 77, i32 0, metadata !65, null}
!153 = metadata !{i32 78, i32 0, metadata !65, null}
!154 = metadata !{i32 80, i32 0, metadata !70, null}
!155 = metadata !{i32 81, i32 0, metadata !70, null}
!156 = metadata !{i32 786689, metadata !32, metadata !"c", metadata !24, i32 16777258, metadata !37, i32 0, metadata !157} ; [ DW_TAG_arg_variable ] [c] [line 42]
!157 = metadata !{i32 82, i32 0, metadata !70, null}
!158 = metadata !{i32 42, i32 0, metadata !32, metadata !157}
!159 = metadata !{i32 786689, metadata !32, metadata !"color", metadata !24, i32 33554474, metadata !27, i32 0, metadata !157} ; [ DW_TAG_arg_variable ] [color] [line 42]
!160 = metadata !{i32 43, i32 0, metadata !32, metadata !157}
!161 = metadata !{i32 786688, metadata !32, metadata !"c16", metadata !24, i32 43, metadata !35, i32 0, metadata !157} ; [ DW_TAG_auto_variable ] [c16] [line 43]
!162 = metadata !{i32 45, i32 0, metadata !32, metadata !157}
!163 = metadata !{i32 83, i32 0, metadata !70, null}
!164 = metadata !{i32 85, i32 0, metadata !79, null}
!165 = metadata !{i32 87, i32 0, metadata !79, null}
!166 = metadata !{i32 90, i32 0, metadata !167, null}
!167 = metadata !{i32 786443, metadata !1, metadata !79, i32 88, i32 0, i32 4} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/kernel.c]
!168 = metadata !{i32 91, i32 0, metadata !167, null}
!169 = metadata !{i32 93, i32 0, metadata !167, null}
!170 = metadata !{i32 94, i32 0, metadata !167, null}
!171 = metadata !{i32 96, i32 0, metadata !167, null}
!172 = metadata !{i32 97, i32 0, metadata !167, null}
!173 = metadata !{i32 105, i32 0, metadata !79, null}
!174 = metadata !{i32 106, i32 0, metadata !85, null}
!175 = metadata !{i32 786689, metadata !79, metadata !"c", metadata !24, i32 16777301, metadata !37, i32 0, metadata !176} ; [ DW_TAG_arg_variable ] [c] [line 85]
!176 = metadata !{i32 108, i32 0, metadata !177, null}
!177 = metadata !{i32 786443, metadata !1, metadata !85, i32 108, i32 0, i32 5} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/kernel.c]
!178 = metadata !{i32 85, i32 0, metadata !79, metadata !176}
!179 = metadata !{i32 87, i32 0, metadata !79, metadata !176}
!180 = metadata !{i32 90, i32 0, metadata !167, metadata !176}
!181 = metadata !{i32 91, i32 0, metadata !167, metadata !176}
!182 = metadata !{i32 93, i32 0, metadata !167, metadata !176}
!183 = metadata !{i32 94, i32 0, metadata !167, metadata !176}
!184 = metadata !{i32 96, i32 0, metadata !167, metadata !176}
!185 = metadata !{i32 97, i32 0, metadata !167, metadata !176}
!186 = metadata !{i32 112, i32 0, metadata !85, null}
!187 = metadata !{i32 786689, metadata !70, metadata !"c", metadata !24, i32 16777296, metadata !37, i32 0, metadata !186} ; [ DW_TAG_arg_variable ] [c] [line 80]
!188 = metadata !{i32 80, i32 0, metadata !70, metadata !186}
!189 = metadata !{i32 786689, metadata !70, metadata !"color", metadata !24, i32 33554512, metadata !27, i32 0, metadata !186} ; [ DW_TAG_arg_variable ] [color] [line 80]
!190 = metadata !{i32 786689, metadata !70, metadata !"x", metadata !24, i32 50331728, metadata !46, i32 0, metadata !186} ; [ DW_TAG_arg_variable ] [x] [line 80]
!191 = metadata !{i32 786689, metadata !70, metadata !"y", metadata !24, i32 67108944, metadata !46, i32 0, metadata !186} ; [ DW_TAG_arg_variable ] [y] [line 80]
!192 = metadata !{i32 81, i32 0, metadata !70, metadata !186}
!193 = metadata !{i32 786688, metadata !70, metadata !"index", metadata !24, i32 81, metadata !64, i32 0, metadata !186} ; [ DW_TAG_auto_variable ] [index] [line 81]
!194 = metadata !{i32 786689, metadata !32, metadata !"c", metadata !24, i32 16777258, metadata !37, i32 0, metadata !195} ; [ DW_TAG_arg_variable ] [c] [line 42]
!195 = metadata !{i32 82, i32 0, metadata !70, metadata !186}
!196 = metadata !{i32 42, i32 0, metadata !32, metadata !195}
!197 = metadata !{i32 786689, metadata !32, metadata !"color", metadata !24, i32 33554474, metadata !27, i32 0, metadata !195} ; [ DW_TAG_arg_variable ] [color] [line 42]
!198 = metadata !{i32 43, i32 0, metadata !32, metadata !195}
!199 = metadata !{i32 786688, metadata !32, metadata !"c16", metadata !24, i32 43, metadata !35, i32 0, metadata !195} ; [ DW_TAG_auto_variable ] [c16] [line 43]
!200 = metadata !{i32 45, i32 0, metadata !32, metadata !195}
!201 = metadata !{i32 113, i32 0, metadata !202, null}
!202 = metadata !{i32 786443, metadata !1, metadata !85, i32 113, i32 0, i32 7} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/kernel.c]
!203 = metadata !{i32 114, i32 0, metadata !204, null}
!204 = metadata !{i32 786443, metadata !1, metadata !202, i32 113, i32 0, i32 8} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/kernel.c]
!205 = metadata !{i32 115, i32 0, metadata !206, null}
!206 = metadata !{i32 786443, metadata !1, metadata !204, i32 115, i32 0, i32 9} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/kernel.c]
!207 = metadata !{i32 116, i32 0, metadata !208, null}
!208 = metadata !{i32 786443, metadata !1, metadata !206, i32 115, i32 0, i32 10} ; [ DW_TAG_lexical_block ] [/home/gbps/Desktop/Projects/os_notshared/pandos/src/kernel.c]
!209 = metadata !{i32 118, i32 0, metadata !204, null}
!210 = metadata !{i32 119, i32 0, metadata !85, null}
!211 = metadata !{i32 121, i32 0, metadata !90, null}
!212 = metadata !{i32 786689, metadata !43, metadata !"str", metadata !24, i32 16777264, metadata !48, i32 0, metadata !213} ; [ DW_TAG_arg_variable ] [str] [line 48]
!213 = metadata !{i32 122, i32 0, metadata !90, null}
!214 = metadata !{i32 48, i32 0, metadata !43, metadata !213}
!215 = metadata !{i32 786688, metadata !43, metadata !"ret", metadata !24, i32 49, metadata !46, i32 0, metadata !213} ; [ DW_TAG_auto_variable ] [ret] [line 49]
!216 = metadata !{i32 49, i32 0, metadata !43, metadata !213}
!217 = metadata !{i32 50, i32 0, metadata !43, metadata !213}
!218 = metadata !{i32 51, i32 0, metadata !43, metadata !213}
!219 = metadata !{i32 123, i32 0, metadata !97, null}
!220 = metadata !{i32 124, i32 0, metadata !97, null}
!221 = metadata !{i32 786689, metadata !85, metadata !"c", metadata !24, i32 16777322, metadata !37, i32 0, metadata !220} ; [ DW_TAG_arg_variable ] [c] [line 106]
!222 = metadata !{i32 106, i32 0, metadata !85, metadata !220}
!223 = metadata !{i32 786689, metadata !79, metadata !"c", metadata !24, i32 16777301, metadata !37, i32 0, metadata !224} ; [ DW_TAG_arg_variable ] [c] [line 85]
!224 = metadata !{i32 108, i32 0, metadata !177, metadata !220}
!225 = metadata !{i32 85, i32 0, metadata !79, metadata !224}
!226 = metadata !{i32 87, i32 0, metadata !79, metadata !224}
!227 = metadata !{i32 90, i32 0, metadata !167, metadata !224}
!228 = metadata !{i32 91, i32 0, metadata !167, metadata !224}
!229 = metadata !{i32 93, i32 0, metadata !167, metadata !224}
!230 = metadata !{i32 94, i32 0, metadata !167, metadata !224}
!231 = metadata !{i32 96, i32 0, metadata !167, metadata !224}
!232 = metadata !{i32 97, i32 0, metadata !167, metadata !224}
!233 = metadata !{i32 112, i32 0, metadata !85, metadata !220}
!234 = metadata !{i32 786689, metadata !70, metadata !"c", metadata !24, i32 16777296, metadata !37, i32 0, metadata !233} ; [ DW_TAG_arg_variable ] [c] [line 80]
!235 = metadata !{i32 80, i32 0, metadata !70, metadata !233}
!236 = metadata !{i32 786689, metadata !70, metadata !"color", metadata !24, i32 33554512, metadata !27, i32 0, metadata !233} ; [ DW_TAG_arg_variable ] [color] [line 80]
!237 = metadata !{i32 786689, metadata !70, metadata !"x", metadata !24, i32 50331728, metadata !46, i32 0, metadata !233} ; [ DW_TAG_arg_variable ] [x] [line 80]
!238 = metadata !{i32 786689, metadata !70, metadata !"y", metadata !24, i32 67108944, metadata !46, i32 0, metadata !233} ; [ DW_TAG_arg_variable ] [y] [line 80]
!239 = metadata !{i32 81, i32 0, metadata !70, metadata !233}
!240 = metadata !{i32 786688, metadata !70, metadata !"index", metadata !24, i32 81, metadata !64, i32 0, metadata !233} ; [ DW_TAG_auto_variable ] [index] [line 81]
!241 = metadata !{i32 786689, metadata !32, metadata !"c", metadata !24, i32 16777258, metadata !37, i32 0, metadata !242} ; [ DW_TAG_arg_variable ] [c] [line 42]
!242 = metadata !{i32 82, i32 0, metadata !70, metadata !233}
!243 = metadata !{i32 42, i32 0, metadata !32, metadata !242}
!244 = metadata !{i32 786689, metadata !32, metadata !"color", metadata !24, i32 33554474, metadata !27, i32 0, metadata !242} ; [ DW_TAG_arg_variable ] [color] [line 42]
!245 = metadata !{i32 43, i32 0, metadata !32, metadata !242}
!246 = metadata !{i32 786688, metadata !32, metadata !"c16", metadata !24, i32 43, metadata !35, i32 0, metadata !242} ; [ DW_TAG_auto_variable ] [c16] [line 43]
!247 = metadata !{i32 45, i32 0, metadata !32, metadata !242}
!248 = metadata !{i32 113, i32 0, metadata !202, metadata !220}
!249 = metadata !{i32 114, i32 0, metadata !204, metadata !220}
!250 = metadata !{i32 115, i32 0, metadata !206, metadata !220}
!251 = metadata !{i32 116, i32 0, metadata !208, metadata !220}
!252 = metadata !{i32 118, i32 0, metadata !204, metadata !220}
!253 = metadata !{i32 125, i32 0, metadata !90, null}
!254 = metadata !{i32 64, i32 0, metadata !53, metadata !255}
!255 = metadata !{i32 132, i32 0, metadata !98, null}
!256 = metadata !{i32 65, i32 0, metadata !53, metadata !255}
!257 = metadata !{i32 786689, metadata !23, metadata !"fg", metadata !24, i32 16777254, metadata !3, i32 0, metadata !258} ; [ DW_TAG_arg_variable ] [fg] [line 38]
!258 = metadata !{i32 66, i32 0, metadata !53, metadata !255}
!259 = metadata !{i32 38, i32 0, metadata !23, metadata !258}
!260 = metadata !{i32 786689, metadata !23, metadata !"bg", metadata !24, i32 33554470, metadata !3, i32 0, metadata !258} ; [ DW_TAG_arg_variable ] [bg] [line 38]
!261 = metadata !{i32 67, i32 0, metadata !53, metadata !255}
!262 = metadata !{i32 786688, metadata !58, metadata !"y", metadata !24, i32 68, metadata !46, i32 0, metadata !255} ; [ DW_TAG_auto_variable ] [y] [line 68]
!263 = metadata !{i32 68, i32 0, metadata !58, metadata !255}
!264 = metadata !{i32 70, i32 0, metadata !63, metadata !255}
!265 = metadata !{i32 69, i32 0, metadata !60, metadata !255}
!266 = metadata !{i32 786688, metadata !63, metadata !"index", metadata !24, i32 70, metadata !64, i32 0, metadata !255} ; [ DW_TAG_auto_variable ] [index] [line 70]
!267 = metadata !{i32 71, i32 0, metadata !63, metadata !255}
!268 = metadata !{i32 786689, metadata !32, metadata !"c", metadata !24, i32 16777258, metadata !37, i32 0, metadata !267} ; [ DW_TAG_arg_variable ] [c] [line 42]
!269 = metadata !{i32 42, i32 0, metadata !32, metadata !267}
!270 = metadata !{i32 786689, metadata !32, metadata !"color", metadata !24, i32 33554474, metadata !27, i32 0, metadata !267} ; [ DW_TAG_arg_variable ] [color] [line 42]
!271 = metadata !{i32 786688, metadata !32, metadata !"c16", metadata !24, i32 43, metadata !35, i32 0, metadata !267} ; [ DW_TAG_auto_variable ] [c16] [line 43]
!272 = metadata !{i32 43, i32 0, metadata !32, metadata !267}
!273 = metadata !{i32 45, i32 0, metadata !32, metadata !267}
!274 = metadata !{i32 786688, metadata !60, metadata !"x", metadata !24, i32 69, metadata !46, i32 0, metadata !255} ; [ DW_TAG_auto_variable ] [x] [line 69]
!275 = metadata !{i32 124, i32 0, metadata !97, metadata !276}
!276 = metadata !{i32 138, i32 0, metadata !98, null}
!277 = metadata !{i32 786689, metadata !85, metadata !"c", metadata !24, i32 16777322, metadata !37, i32 0, metadata !275} ; [ DW_TAG_arg_variable ] [c] [line 106]
!278 = metadata !{i32 106, i32 0, metadata !85, metadata !275}
!279 = metadata !{i32 786689, metadata !79, metadata !"c", metadata !24, i32 16777301, metadata !37, i32 0, metadata !280} ; [ DW_TAG_arg_variable ] [c] [line 85]
!280 = metadata !{i32 108, i32 0, metadata !177, metadata !275}
!281 = metadata !{i32 85, i32 0, metadata !79, metadata !280}
!282 = metadata !{i32 87, i32 0, metadata !79, metadata !280}
!283 = metadata !{i32 90, i32 0, metadata !167, metadata !280}
!284 = metadata !{i32 91, i32 0, metadata !167, metadata !280}
!285 = metadata !{i32 93, i32 0, metadata !167, metadata !280}
!286 = metadata !{i32 94, i32 0, metadata !167, metadata !280}
!287 = metadata !{i32 96, i32 0, metadata !167, metadata !280}
!288 = metadata !{i32 97, i32 0, metadata !167, metadata !280}
!289 = metadata !{i32 112, i32 0, metadata !85, metadata !275}
!290 = metadata !{i32 786689, metadata !70, metadata !"c", metadata !24, i32 16777296, metadata !37, i32 0, metadata !289} ; [ DW_TAG_arg_variable ] [c] [line 80]
!291 = metadata !{i32 80, i32 0, metadata !70, metadata !289}
!292 = metadata !{i32 786689, metadata !70, metadata !"color", metadata !24, i32 33554512, metadata !27, i32 0, metadata !289} ; [ DW_TAG_arg_variable ] [color] [line 80]
!293 = metadata !{i32 786689, metadata !70, metadata !"x", metadata !24, i32 50331728, metadata !46, i32 0, metadata !289} ; [ DW_TAG_arg_variable ] [x] [line 80]
!294 = metadata !{i32 786689, metadata !70, metadata !"y", metadata !24, i32 67108944, metadata !46, i32 0, metadata !289} ; [ DW_TAG_arg_variable ] [y] [line 80]
!295 = metadata !{i32 81, i32 0, metadata !70, metadata !289}
!296 = metadata !{i32 786688, metadata !70, metadata !"index", metadata !24, i32 81, metadata !64, i32 0, metadata !289} ; [ DW_TAG_auto_variable ] [index] [line 81]
!297 = metadata !{i32 786689, metadata !32, metadata !"c", metadata !24, i32 16777258, metadata !37, i32 0, metadata !298} ; [ DW_TAG_arg_variable ] [c] [line 42]
!298 = metadata !{i32 82, i32 0, metadata !70, metadata !289}
!299 = metadata !{i32 42, i32 0, metadata !32, metadata !298}
!300 = metadata !{i32 786689, metadata !32, metadata !"color", metadata !24, i32 33554474, metadata !27, i32 0, metadata !298} ; [ DW_TAG_arg_variable ] [color] [line 42]
!301 = metadata !{i32 43, i32 0, metadata !32, metadata !298}
!302 = metadata !{i32 786688, metadata !32, metadata !"c16", metadata !24, i32 43, metadata !35, i32 0, metadata !298} ; [ DW_TAG_auto_variable ] [c16] [line 43]
!303 = metadata !{i32 45, i32 0, metadata !32, metadata !298}
!304 = metadata !{i32 113, i32 0, metadata !202, metadata !275}
!305 = metadata !{i32 114, i32 0, metadata !204, metadata !275}
!306 = metadata !{i32 115, i32 0, metadata !206, metadata !275}
!307 = metadata !{i32 116, i32 0, metadata !208, metadata !275}
!308 = metadata !{i32 118, i32 0, metadata !204, metadata !275}
!309 = metadata !{i32 123, i32 0, metadata !97, metadata !276}
!310 = metadata !{i32 786688, metadata !97, metadata !"i", metadata !24, i32 123, metadata !46, i32 0, metadata !276} ; [ DW_TAG_auto_variable ] [i] [line 123]
!311 = metadata !{i32 140, i32 0, metadata !98, null}
!312 = metadata !{i32 141, i32 0, metadata !98, null}
