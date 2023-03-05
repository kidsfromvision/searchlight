import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="leaderboard"
export default class extends Controller {
  connect() {
    document
      .querySelectorAll("th")
      .forEach((th) =>
        th.addEventListener("click", this.handleHeaderClick.bind(this))
      );
  }

  handleHeaderClick(event) {
    // prevent behaviour if they click the wrong thing
    if (event.srcElement.localName === "th") {
      return null;
    }

    // remove all other sort directions when one is clicked
    this.element.querySelectorAll("th").forEach((th) => {
      if (th.id !== event.srcElement.parentElement.id) {
        th.removeAttribute("data-sort-direction");
        this.showArrow(null, th);
      }
    });

    var clickedTableHeaderList = Array.from(
      this.element.querySelectorAll("th")
    ).filter((th) => th.id === event.srcElement.parentElement.id);

    var clickedTableHeader = clickedTableHeaderList[0];

    if (clickedTableHeader.getAttribute("data-sort-direction") === "asc") {
      clickedTableHeader.setAttribute("data-sort-direction", "desc");
      this.sortTable(clickedTableHeader.id, "desc");
      this.showArrow("desc", clickedTableHeader);
    } else if (
      clickedTableHeader.getAttribute("data-sort-direction") === "desc"
    ) {
      clickedTableHeader.removeAttribute("data-sort-direction");
      this.sortTable(clickedTableHeader.id, null);
      this.showArrow(null, clickedTableHeader);
    } else {
      clickedTableHeader.setAttribute("data-sort-direction", "asc");
      this.sortTable(clickedTableHeader.id, "asc");
      this.showArrow("asc", clickedTableHeader);
    }
  }

  sortTable(columnName, direction) {
    if (direction === null) {
      this.sortByDailyStreams("desc");
    } else if (columnName === "name") {
      this.sortByName(direction);
    } else if (columnName === "daily_streams") {
      this.sortByDailyStreams(direction);
    } else if (columnName === "genres") {
      this.sortByGenres(direction);
    } else if (columnName === "status") {
      this.sortByStatus(direction);
    } else if (columnName === "added_by") {
      this.sortByAddedBy(direction);
    }
  }

  sortByName(direction) {
    var table = this.element;
    var rows = Array.from(table.rows).slice(1);
    var sortedRows = rows.sort((a, b) => {
      if (direction === "asc") {
        return a.cells[0].innerText.localeCompare(b.cells[0].innerText);
      } else if (direction === "desc") {
        return b.cells[0].innerText.localeCompare(a.cells[0].innerText);
      }
    });
    rows.forEach((row) => row.remove());
    sortedRows.forEach((row) => table.appendChild(row));
  }

  sortByDailyStreams(direction) {
    var table = this.element;
    var rows = Array.from(table.rows).slice(1);
    var sortedRows = rows.sort((a, b) => {
      if (direction === "asc") {
        return (
          parseInt(a.cells[1].innerText.split("\n")[0].replaceAll(",", "")) -
          parseInt(b.cells[1].innerText.split("\n")[0].replaceAll(",", ""))
        );
      } else if (direction === "desc") {
        return (
          parseInt(b.cells[1].innerText.split("\n")[0].replaceAll(",", "")) -
          parseInt(a.cells[1].innerText.split("\n")[0].replaceAll(",", ""))
        );
      }
    });
    rows.forEach((row) => row.remove());
    sortedRows.forEach((row) => table.appendChild(row));
  }

  sortByGenres(direction) {
    var table = this.element;
    var rows = Array.from(table.rows).slice(1);
    var sortedRows = rows.sort((a, b) => {
      if (direction === "asc") {
        return a.cells[2].innerText.localeCompare(b.cells[2].innerText);
      } else if (direction === "desc") {
        return b.cells[2].innerText.localeCompare(a.cells[2].innerText);
      }
    });
    rows.forEach((row) => row.remove());
    sortedRows.forEach((row) => table.appendChild(row));
  }

  sortByStatus(direction) {
    var table = this.element;
    var rows = Array.from(table.rows).slice(1);
    var sortedRows = rows.sort((a, b) => {
      var aSelector = Array.from(a.cells[3].children[0].children).find(
        (child) => {
          return child.localName === "select";
        }
      );

      var bSelector = Array.from(b.cells[3].children[0].children).find(
        (child) => {
          return child.localName === "select";
        }
      );

      if (direction === "asc") {
        return (
          aSelector.options.selectedIndex - bSelector.options.selectedIndex
        );
      } else if (direction === "desc") {
        return (
          bSelector.options.selectedIndex - aSelector.options.selectedIndex
        );
      }
    });
    Array.from(this.element).forEach((row) => row.remove());
    sortedRows.forEach((row) => table.appendChild(row));
  }

  sortByAddedBy(direction) {
    var table = this.element;
    var rows = Array.from(table.rows).slice(1);
    var sortedRows = rows.sort((a, b) => {
      if (direction === "asc") {
        return a.cells[4].innerText.localeCompare(b.cells[4].innerText);
      } else if (direction === "desc") {
        return b.cells[4].innerText.localeCompare(a.cells[4].innerText);
      }
    });
    rows.forEach((row) => row.remove());
    sortedRows.forEach((row) => table.appendChild(row));
  }

  showArrow(direction, element) {
    var headerChildren = Array.from(element.children[0].children);

    var upArrow = headerChildren[0];
    var downArrow = headerChildren[1];
    var placeholderArrow = headerChildren[2];

    if (direction === "asc") {
      upArrow.removeAttribute("hidden");
      downArrow.setAttribute("hidden", true);
      placeholderArrow.setAttribute("hidden", true);
    } else if (direction === "desc") {
      upArrow.setAttribute("hidden", true);
      downArrow.removeAttribute("hidden");
      placeholderArrow.setAttribute("hidden", true);
    } else {
      upArrow.setAttribute("hidden", true);
      downArrow.setAttribute("hidden", true);
      placeholderArrow.removeAttribute("hidden");
    }
  }
}
