## 1.2.0

* Add `Measure#data_at(at_predicate)` to let Measure fine-tune queries
  themselves (such as pushing the predicate down a Bmg tree). The default
  implementation is backward compatible and simply restrict the relation
  sent by `full_data`.

* Add `--last=Ndays` commandline option, to select a time window with N
  days in the past (today included).

* Add `--since=date` commandline option, to select a time window since a
  particular date.

* Add `--between=from,to` commandline option, to select a time window between
  two dates.

## 1.1.1

* `matt export` now correctly support a variable number of measure names.
  Passing no measure name exports them all.

## 1.1.0 - 2021-06-10

* Added `Matt.env!` to use an env variable that must exist.

* Added --silent and --verbose options for various debug levels.

* Sql::Exporter now support various info & debug messages to better inspect
  database table alignments and data export tasks.

## 1.0.0 - 2021-06-09

* First official version used in production.

## 0.0.1 - 2021-06-07

* Birthday
