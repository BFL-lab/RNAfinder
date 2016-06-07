# RNAweasel

This program will search for and identify RNAs. 
It is a wrapper around a search tool called [erpin](http://rna.igmors.u-psud.fr/Software/erpin.php).

This package is based on activities of the OGMP, and becomes open source as part of MFannot.

## Install

In order to run RNAweasel you need:
1. Install [erpin](http://rna.igmors.u-psud.fr/Software/erpin.php) on your system. 
2. Install the [PirObject](https://github.com/prioux/PirObject) library.
3. Install all the necessary [PirModels](https://github.com/BFL-lab/PirModels).
4. Install the BioPerl library [Bio::Tools::CodonTable](http://search.cpan.org/dist/BioPerl/Bio/Tools/CodonTable.pm)
5. Copy the `DOT_RNAfinder.cfg` in your home directory under `.RNAfinder.cfg` or under the directory defined by the `RNAFINDER_CFG_PATH` environment variable. 
6. Copy `RNAweasel` file in one of your executable directory (e.g: a directory list in $PATH).

## Usage

Once RNAweasel installed just call `RNAweasel -h` to get the complete help.

## Contributing

Please see [CONTRIBUTING](CONTRIBUTING.md) and [CONDUCT](CONDUCT.md) for details.

## Credits

- [All Contributors](https://github.com/BFL-lab/RNAweasel/graphs/contributors)

## License

GNU General Public License v3.0. Please see [License File](LICENSE.md) for more information.
