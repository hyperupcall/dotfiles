# History

My original dotfile manager lived at [hyperupcall/dots-bootstrap](https://github.com/hyperupcall/dots-bootstrap), but I moved it into [hyperupcall/dots](https://github.com/dots) to make maintenance easier

Sometime thereafter, I moved tools related to dotfile management (specifically [hyperupcall/dotshellextract](https://github.com/hyperupcall/dotshellextract) and [dotshellgen](https://github.com/hyperupcall/dotshellgen)) to `hyperupcall/dots`

For many many months, this proved to be a fantastic setup, especially since I was actively developing the "management" aspect of my dotfiles (along with the "configuration" aspect of course)

But, once again, I wanted to separate the "management" and "configuration" aspect of `dotmgr`. Since `dotmgr` was relatively stable, this would benefit `hyperupcall/dots` by making things more declarative. Additionally, it would make it easier for others to use `dotmgr`, if they wished to experiment with, or use it

Henceforth, [hyperupcall/dotmgr](https://github.com/hyperupcall/dotmgr) was created. I used [git-filter-repo](https://github.com/newren/git-filter-repo) to extract the previous `./bootstrap/dotmgr` directory to its own repository

The project was rewritten in Rust in January, 2022.
