./configure &&
make mandoc

install -vm755 mandoc   /usr/bin &&
install -vm644 mandoc.1 /usr/share/man/man1
