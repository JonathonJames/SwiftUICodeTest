# SwiftUICodeTest

This is an MVVM app using Swift UI, designed to have a fallback, offline experience. I've not used SwiftUI professionally before so I'm sure I have some knowledge gaps in regards to best practices. I've just dabbled for personal projects to get a general feeling for how the technology works.

Test coverage is limited. Would have liked to do more (particularly UI tests). Particularly using config flags for creating a mock appp, giving more fine-grained control during the tests.

Still a lot to be done, realy. But Hopefully you can see the genesis of where I'm heading and the way that I deal with things.

A couple of obvious issues which I know I need to look at but haven't had time:
- Issues with GRDB persistence. Not used it previously. Clearly got something wrong with the setup here, but run out of time to investigate further. But what I was aiming for with the Repository pattern can be seen with the surrounding code.
- The fade-out of the "Connection Lost"/"Connection Restored" toast. There's evidently an issue here with how the state is updating. The toast just disappears instantaneously. A Google search doesn't seem to suggest anything other than what I'm doing as the answer. The view state is clearly changing and removing the toast too soon. Would need further investigation to see what the issue is.
