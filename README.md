Docker container for cordcutting automation.

This includes several popular clients to download TV, Movies, etc from usenet and torrents.  The list:
* Sonarr (TV/Anime)
* CouchPotato (Movies)
* Headphones (Music)
* Mylar (Comic Books)
* LazyLibrarian (Books)
* NZBGet (Usenet Downloader)
* Transmission (Torrent Downloader)

# Quickstart
Until I get this on docker hub:
* Download the repo: `git clone https://github.com/dackidvich/cordcutter-docker`
* Set ports if needed (example in file for Transmission), and edit volume locations for Media and Configuration: `edit docker-run.sh`
* Build the container: `sudo ./docker-create.sh`
* Run the container: `sudo ./docker-run.sh`

# Why the project
This project uses what is currently the latest version of all products that have been tricky to get correctly, such as Mono 4.4.1.
Upon reboot, every app gets cleaned out and checked for latest versions, which can help fix broken updates.
I've seen many posts on various subreddits about getting apps to run, or why something won't start, etc.  Hopefully this project is easier to use for some.
