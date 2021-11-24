lbi r5, 24
lbi r4, 25
sle r6, r5, r4
beqz r6, .afternop
nop
.afternop:
nop
bnez r6, .afternop2
nop
.afternop2:
nop
halt