repr_list_generic <- function(
	vec, fmt,
	enum.item, named.item, only.named.item,
	enum.wrap, named.wrap = enum.wrap,
	...,
	numeric.item = named.item,
	item.uses.numbers = FALSE) {
	
	nms <- names(vec)
	char.vec <- as.character(vec)
	
	mapped <- lapply(vec, format2repr[[fmt]])
	
	if (length(mapped) == 1 && !is.null(nms)) {
		ret <- sprintf(only.named.item, nms, mapped[[1]])
	} else {
		if (is.null(nms)) {
			if (item.uses.numbers)
				entries <- sprintf(enum.item, seq_along(mapped), mapped)
			else
				entries <- sprintf(enum.item, mapped)
		} else {
			entries <- vapply(seq_along(mapped), function(i) {
				nm <- nms[[i]]
				if (is.na(nm) || nchar(nm) == 0) {
					sprintf(numeric.item, i, mapped[[i]])
				} else {
					sprintf(named.item, nms[[i]], mapped[[i]])
				}
			}, character(1))
		}
		
		wrap <- if (is.null(nms)) enum.wrap else named.wrap
		
		ret <- sprintf(wrap, paste0(entries, collapse = ''))
	}
	ret
}



#' HTML representation of a list
#' 
#' @export
repr_html.list <- function(li, ...) repr_list_generic(
	li, 'html',
	'\t<li>%s</li>\n',
	'\t<dt>$%s</dt>\n\t\t<dd>%s</dd>\n',
	'<strong>$%s</strong> = %s',
	'<ol>\n%s</ol>\n',
	'<dl>\n%s</dl>\n',
	numeric.item = '\t<dt>[[%s]]</dt>\n\t\t<dd>%s</dd>\n')



#' Markdown representation of a list
#' 
#' @export
repr_markdown.list <- function(li, ...) repr_list_generic(
	li, 'markdown',
	'%s. %s\n',
	'$%s\n:   %s\n',
	'**$%s** = %s',
	'%s\n\n',
	numeric.item = '[[%s]]\n:   %s\n',
	item.uses.numbers = TRUE)



#' LaTeX representation of a list
#' 
#' @export
repr_latex.list <- function(li, ...) repr_list_generic(
	li, 'latex',
	'\\item %s\n',
	'\\item[\\$%s] %s\n',
	'\\textbf{\\$%s} = %s',
	enum.wrap  = '\\begin{enumerate}\n%s\\end{enumerate}\n',
	named.wrap = '\\begin{description}\n%s\\end{description}\n',
	numeric.item = '\\item[{[[%s]]}] %s\n')
