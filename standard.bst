% BibTeX bibliography style `standard'
% entwickelt aus style `unsrt' von O. Patashnik
        % version 0.99a for BibTeX versions 0.99a or later, LaTeX version 2.09.
        % Copyright (C) 1985, all rights reserved.
        % Copying of this file is authorized only if either
        % (1) you make absolutely no changes to your copy, including name, or
        % (2) if you do make changes, you name it something other than
        % btxbst.doc, plain.bst, unsrt.bst, alpha.bst, and abbrv.bst.
        % This restriction helps ensure that all standard styles are identical.
        % The file btxbst.doc has the documentation for this style.

ENTRY
  { address
    altjournal
    altmonth
    altnumber
    altpages
    alttitle
    altvolume
    altyear
    author
    booktitle
    chapter
    edition
    editor
    howpublished
    institution
    journal
    key
    month
    note
    number
    organization
    pages
    publisher
    school
    series
    title
    type
    volume
    year
  }
  {}
  { label }

INTEGERS { output.state before.all mid.sentence after.sentence after.block }

FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
}

STRINGS { s t }

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}


FUNCTION {output.nonnull}
{ 's :=
  output.state mid.sentence =
    { write$ }
    { output.state after.block =
        { add.period$ write$
          newline$
          "\newblock " write$
        }
        { output.state before.all =
            'write$
            { add.period$ " " * write$ }
          if$
        }
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}

FUNCTION {output}
{ duplicate$ empty$
    'pop$
    'output.nonnull
  if$
}

FUNCTION {output.strichpunkt}
{ duplicate$ empty$
    'pop$
    { output.state after.block = not
      { output.state mid.sentence =
        {"; " swap$ *}
        'skip$
        if$
      }
      'skip$
      if$
    output.nonnull }
  if$
}

FUNCTION {output.komma}
{ duplicate$ empty$
    'pop$
    { output.state after.block = not
      { output.state mid.sentence =
        {", " swap$ *}
        'skip$
        if$
      }
      'skip$
      if$
    output.nonnull }
  if$
}

FUNCTION {output.blank}
{ duplicate$ empty$
    'pop$
    { output.state after.block = not
      { output.state mid.sentence =
        {" " swap$ *}
        'skip$
        if$
      }
      'skip$
      if$
    output.nonnull }
  if$
}

FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull
  if$
}

FUNCTION {output.check.komma}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    { output.state after.block = not
      {output.state mid.sentence =
        { ", " swap$ *}
        'skip$
        if$
      }
      'skip$
      if$
    output.nonnull }
  if$
}

FUNCTION {output.check.blank}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    { output.state after.block = not
      {output.state mid.sentence =
        { " " swap$ *}
        'skip$
        if$
      }
      'skip$
      if$
    output.nonnull }
  if$
}

FUNCTION {output.bibitem}
{ newline$
  "\bibitem{" write$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {fin.entry}
{ add.period$
  write$
  newline$
}

FUNCTION {new.block}
{ output.state before.all =
    'skip$
    { after.block 'output.state := }
  if$
}

FUNCTION {new.sentence}
{ output.state after.block =
    'skip$
    { output.state before.all =
        'skip$
        { after.sentence 'output.state := }
      if$
    }
  if$
}

FUNCTION {new.block.checka}
{ empty$
    'skip$
    'new.block
  if$
}

FUNCTION {new.block.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.block
  if$
}

FUNCTION {new.sentence.checka}
{ empty$
    'skip$
    'new.sentence
  if$
}

FUNCTION {new.sentence.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.sentence
  if$
}

FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

FUNCTION {smallcaps}
{ duplicate$ empty$
    { pop$ "" }
    { "{\sc " swap$ * "}" * }
  if$
}

FUNCTION {emphasize}
{ duplicate$ empty$
    { pop$ "" }
    { "{\em " swap$ * "}" * }
  if$
}

INTEGERS { nameptr namesleft numnames }

FUNCTION {format.names}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr "{ff~}{vv~}{ll}{, jj}" format.name$ smallcaps 't :=
      nameptr #1 >
        { namesleft #1 >
            { ", " * t * }
            { numnames #2 >
                { " " * }
                'skip$
              if$
              t "{\sc others}" =
                { " et~al." * }
                { " und " * t * }
              if$
            }
          if$
        }
        't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {format.authors}
{ author empty$
    { "" }
    { author format.names }
  if$
}

FUNCTION {format.editors}
{ editor empty$
    { "" }
    { editor format.names
      editor num.names$ #1 >
        { " (Hrsg.)" * }
        { " (Hrsg.)" * }
      if$
    }
  if$
}

FUNCTION {format.title}
{ title empty$
    { "" }
    { title ", " * }
  if$
}

FUNCTION {n.dashify}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
        { t #1 #2 substring$ "--" = not
            { "--" *
              t #2 global.max$ substring$ 't :=
            }
            {   { t #1 #1 substring$ "-" = }
                { "-" *
                  t #2 global.max$ substring$ 't :=
                }
              while$
            }
          if$
        }
        { t #1 #1 substring$ *
          t #2 global.max$ substring$ 't :=
        }
      if$
    }
  while$
}

FUNCTION {format.date}
{ year empty$
    { month empty$
        { "" }
        { "there's a month but no year in " cite$ * warning$
          month
        }
      if$
    }
    { month empty$
        { "(" year * ")" * }
        { month " (" * year * ")" *}
      if$
    }
  if$
}

FUNCTION {format.altdate}
{ altyear empty$
    { altmonth empty$
        { "" }
        { "alternate publication: there's a month but no year in " 
          cite$ * warning$
          altmonth
        }
      if$
    }
    { altmonth empty$
        { "(" altyear * ")" * }
        { altmonth " (" * altyear * ")" *}
      if$
    }
  if$
}

FUNCTION {format.date.ohneKlammer}
{ year empty$
    { month empty$
        { "" }
        { "there's a month but no year in " cite$ * warning$
          month
        }
      if$
    }
    { month empty$
        'year 
        { month " " * year * }
      if$
    }
  if$
}

FUNCTION {format.btitle}
{ title emphasize 
}

FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "~" }
    { " " }
  if$
  swap$ * *
}

FUNCTION {either.or.check}
{ empty$
    'pop$
    { "can't use both " swap$ * " fields in " * cite$ * warning$ }
  if$
}

FUNCTION {format.bvolume}
{ volume empty$
    { "" }
    { " Band" volume tie.or.space.connect
      series empty$
        'skip$
        { ", " * series emphasize * }
      if$
      "volume and number" number either.or.check
    }
  if$
}

FUNCTION {format.number.series}
{ volume empty$
    { number empty$
        { series field.or.null }
        { output.state mid.sentence =
            { "number" }
            { "Number" }
          if$
          number tie.or.space.connect
          series empty$
            { "there's a number but no series in " cite$ * warning$ }
            { " in " * series * }
          if$
        }
      if$
    }
    { "" }
  if$
}

FUNCTION {format.edition}
{ edition empty$
    { "" }
    { output.state mid.sentence =
        { edition "l" change.case$ " Auflage" * }
        { edition "t" change.case$ " Auflage" * }
      if$
    }
  if$
}

INTEGERS { multiresult }

FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not
      t empty$ not
      and
    }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
        { #1 'multiresult := }
        { t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}

FUNCTION {format.pages}
{ pages empty$
    { "" }
    { pages multi.page.check
    		%{ "pp. " pages n.dashify tie.or.space.connect }
        %{ "p. " pages tie.or.space.connect }
        {  pages n.dashify tie.or.space.connect }
        {  pages tie.or.space.connect }
      if$
    }
  if$
}

FUNCTION {format.altpages}
{ altpages empty$
    { "" }
    { altpages multi.page.check
        { " " altpages n.dashify tie.or.space.connect }
        { " " altpages tie.or.space.connect }
      if$
    }
  if$
}

FUNCTION {format.vol.num.pages}
{ volume field.or.null emphasize
  number empty$
    'skip$
    { "(" number * ")" * *
      volume empty$
        { "there's a number but no volume in " cite$ * warning$ }
        'skip$
      if$
    }
  if$
  pages empty$
    'skip$
    { duplicate$ empty$
        { pop$ format.pages }
        { ", " * pages n.dashify * }
      if$
    }
  if$
}

FUNCTION {format.altvol.altnum.altpages}
{ altvolume field.or.null emphasize
  altnumber empty$
    'skip$
    { "(" altnumber * ")" * *
      altvolume empty$
        { "alternate publication: there's a number but no volume in " 
          cite$ * warning$ }
        'skip$
      if$
    }
  if$
  altpages empty$
    'skip$
    { duplicate$ empty$
        { pop$ format.altpages }
        { ", " * altpages n.dashify * }
      if$
    }
  if$
}

FUNCTION {format.chapter.pages}
{ chapter empty$
    'format.pages
    { type empty$
        { "Kapitel" }
        { type "l" change.case$ }
      if$
      chapter tie.or.space.connect
      pages empty$
        'skip$
        { ", S.\ " * format.pages * }
      if$
    }
  if$
}

FUNCTION {format.in.ed.booktitle}
{ booktitle empty$
    { "" }
    { editor empty$
        { "in " booktitle emphasize * }
        { "in " format.editors * ", " * booktitle emphasize * }
      if$
    }
  if$
}

FUNCTION {empty.misc.check}
{ author empty$ title empty$ howpublished empty$
  month empty$ year empty$ note empty$
  and and and and and
    { "all relevant fields are empty in " cite$ * warning$ }
    'skip$
  if$
}

FUNCTION {format.thesis.type}
{ type empty$
    'skip$
    { pop$
      type "t" change.case$
    }
  if$
}

FUNCTION {format.tr.number}
{ type empty$
    { "Technical Report" }
    'type
  if$
  number empty$
    { "t" change.case$ }
    { number tie.or.space.connect }
  if$
}

FUNCTION {format.article.crossref}
{ key empty$
    { journal empty$
        { "need key or journal for " cite$ * " to crossref " * crossref *
          warning$
          ""
        }
        { "in {\em " journal * "\/}" * }
      if$
    }
    { "in " key * }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {format.crossref.editor}
{ editor #1 "{vv~}{ll}" format.name$
  editor num.names$ duplicate$
  #2 >
    { pop$ " et~al." * }
    { #2 <
        'skip$
        { editor #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =
            { " et~al." * }
            { " und " * editor #2 "{vv~}{ll}" format.name$ * }
          if$
        }
      if$
    }
  if$
}

FUNCTION {format.book.crossref}
{ volume empty$
    { "empty volume in " cite$ * "'s crossref of " * crossref * warning$
      "in "
    }
    { " Band" volume tie.or.space.connect
      " of " *
    }
  if$
  editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
        { series empty$
            { "need editor, key, or series for " cite$ * " to crossref " *
              crossref * warning$
              "" *
            }
            { "{\em " * series * "\/}" * }
          if$
        }
        { key * }
      if$
    }
    { format.crossref.editor * }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {format.incoll.inproc.crossref}
{ editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
        { booktitle empty$
            { "need editor, key, or booktitle for " cite$ * " to crossref " *
              crossref * warning$
              ""
            }
            { "in {\em " booktitle * "\/}" * }
          if$
        }
        { "in " key * }
      if$
    }
    { "in " format.crossref.editor * }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {article}
{ output.bibitem
  format.authors "author" output.check.komma
  crossref missing$
    { journal emphasize "journal" output.check.komma
      format.vol.num.pages output.blank
      format.date "year" output.check.blank
    }
    { format.article.crossref output.blank
      format.pages output.blank
    }
  if$
  altjournal missing$
    {
    }
    {
      altjournal emphasize output.strichpunkt
      format.altvol.altnum.altpages output.blank
      format.altdate "altyear" output.check.blank
    }
  if$
  new.block
  note output
  fin.entry
}

FUNCTION {book}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check.komma }
    { format.authors "author" output.check.komma
      crossref missing$
        { "author and editor" editor either.or.check }
        'skip$
      if$
    }
  if$
  format.btitle "title" output.check.komma
  crossref missing$
    { format.bvolume output.komma
      format.number.series output
      publisher "publisher" output.check.komma
      address output.komma
    }
    { format.book.crossref output.blank
    }
  if$
  format.edition output.komma
  format.date.ohneKlammer "year" output.check.komma
  new.block
  note output
  fin.entry
}

FUNCTION {booklet}
{ output.bibitem
  format.authors output.komma
  format.title "title" output.check.komma
  howpublished output.komma
  address output.komma
  format.date.ohneKlammer output.komma
  new.block
  note output
  fin.entry
}

FUNCTION {inbook}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check.komma }
    { format.authors output.komma
      crossref missing$
        { "author and editor" editor either.or.check }
        'skip$
      if$
    }
  if$
  format.btitle "title" output.check.komma
  crossref missing$
    { format.bvolume output.komma
      format.number.series output.komma
      publisher "publisher" output.check.komma
      address output.komma
      format.chapter.pages "chapter and pages" output.check.komma
    }
    { 
      format.book.crossref output.komma
      format.chapter.pages "chapter and pages" output.check.komma
    }
  if$
  format.edition output.komma
  format.date.ohneKlammer "year" output.check.komma
  new.block
  note output
  fin.entry
}

FUNCTION {incollection}
{ output.bibitem
  format.authors "author" output.check.komma
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check.komma
      format.bvolume output.komma
      format.number.series output.komma
      format.chapter.pages output.komma
      publisher "publisher" output.check.komma
      address output.komma
      format.edition output.komma
      format.date "year" output.check.blank
    }
    { format.incoll.inproc.crossref output.komma
      format.chapter.pages output.komma
    }
  if$
  new.block
  note output
  fin.entry
}

FUNCTION {inproceedings}
{ output.bibitem
  format.authors "author" output.check.komma
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check.komma
      format.bvolume output.komma
      format.number.series output.komma
      format.pages output.komma
      address empty$
        { organization publisher new.sentence.checkb
          organization output.komma
          publisher output.komma
          format.date "year" output.check.blank
        }
        { organization output.komma
          publisher output.komma
          address output.komma
          format.date "year" output.check.blank
        }
      if$
    }
    { format.incoll.inproc.crossref output.komma
      format.pages output.komma
    }
  if$
  new.block
  note output
  fin.entry
}

FUNCTION {conference} { inproceedings }

FUNCTION {manual}
{ output.bibitem
  author empty$
    { organization empty$
        'skip$
        { organization output.komma
          address output.komma
        }
      if$
    }
    { format.authors output.komma }
  if$
  format.btitle "title" output.check.komma
  author empty$
    { organization empty$
        { address output.komma
        }
        'skip$
      if$
    }
    { organization output.komma
      address output.komma
    }
  if$
  format.edition output.komma
  format.date output.komma
  new.block
  note output
  fin.entry
}

FUNCTION {mastersthesis}
{ output.bibitem
  format.authors "author" output.check.komma
  format.title "title" output.check.komma
  "Diplomarbeit" format.thesis.type output.komma
  school "school" output.check.komma
  address output.komma
  format.date.ohneKlammer "year" output.check.komma
  new.block
  note output
  fin.entry
}

FUNCTION {misc}
{ output.bibitem
  format.authors "author" output.check.komma
  format.title "title" output.check.komma
  howpublished output.blank
  format.date.ohneKlammer output.komma
  new.block
  note output
  fin.entry
  empty.misc.check
}

FUNCTION {phdthesis}
{ output.bibitem
  format.authors "author" output.check.komma
  format.btitle "title" output.check.komma
  "Dissertation" format.thesis.type output.komma
  school "school" output.check.komma
  address output.komma
  format.date.ohneKlammer "year" output.check.komma
  new.block
  note output
  fin.entry
}

FUNCTION {proceedings}
{ output.bibitem
  editor empty$
    { organization output.komma }
    { format.editors output.komma }
  if$
  format.btitle "title" output.check.komma
  format.bvolume output.komma
  format.number.series output.komma
  address empty$
    { editor empty$
        { publisher new.sentence.checka }
        { organization output.komma
        }
      if$
      publisher output.komma
      format.date.ohneKlammer "year" output.check.komma
    }
    { address output.komma
      format.date.ohneKLammer "year" output.check.komma
      editor empty$
        'skip$
        { organization output.komma }
      if$
      publisher output.komma
    }
  if$
  new.block
  note output
  fin.entry
}

FUNCTION {techreport}
{ output.bibitem
  format.authors "author" output.check.komma
  format.title "title" output.check.komma
  format.tr.number output.komma
  institution "institution" output.check.komma
  address output.komma
  format.date.ohneKlammer "year" output.check.komma
  new.block
  note output
  fin.entry
}

FUNCTION {unpublished}
{ output.bibitem
  format.authors "author" output.check.komma
  format.title "title" output.check.komma
  note "note" output.check.komma
  format.date.ohneKlammer output.komma
  fin.entry
}

FUNCTION {default.type} { misc }

READ

STRINGS { longest.label }

INTEGERS { number.label longest.label.width }

FUNCTION {initialize.longest.label}
{ "" 'longest.label :=
  #1 'number.label :=
  #0 'longest.label.width :=
}

FUNCTION {longest.label.pass}
{ number.label int.to.str$ 'label :=
  number.label #1 + 'number.label :=
  label width$ longest.label.width >
    { label 'longest.label :=
      label width$ 'longest.label.width :=
    }
    'skip$
  if$
}

EXECUTE {initialize.longest.label}

ITERATE {longest.label.pass}

FUNCTION {begin.bib}
{ preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
  "\begin{thebibliography}{"  longest.label  * "}" * write$ newline$
}

EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}

EXECUTE {end.bib}
