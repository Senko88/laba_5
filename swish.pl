% Версия без использования / и mod
generate_unique_numbers_strict(List) :-
    findall(
        Number,
        (
            between(1, 9, D1),      % Первая цифра (1-9, т.к. число трехзначное)
            between(0, 9, D2),      % Вторая цифра (0-9)
            between(0, 9, D3),      % Третья цифра (0-9)
            D1 \= D2, D1 \= D3, D2 \= D3, % Проверка уникальности
            Number is D1*100 + D2*10 + D3  % Собираем число из цифр
        ),
        List
    ).
% Автоматический вывод при загрузке файла
:- initialization(main, after_load).  % Запустить main после загрузки
main :-
    generate_unique_numbers_strict(List),
    format('Список трехзначных чисел с уникальными цифрами:~n~w~n', [List]),
    length(List, Len),
    format('Всего чисел: ~d~n', [Len]).








% Предикат для вычисления разности max и min
difference_max_min(List, Diff) :-
    List \= [],
    max_list(List, Max),
    min_list(List, Min),
    Diff is Max - Min.

% Главный предикат - запрашивает ввод и выводит результат
start :-
    write('Введите элементы списка через пробел: '),
    read_line_to_string(user_input, InputString),
    split_string(InputString, " ", "", StringList),
    maplist(atom_number, StringList, List), % Преобразуем строки в числа
    (   List \= []
    ->  difference_max_min(List, Diff),
        format('Разность максимального и минимального элементов: ~w~n', [Diff])
    ;   write('Ошибка: список пуст!~n')
    ).
% Запуск при загрузке файла
:- initialization(start).








% Проверка, что Xs — подмножество Ys
subset([], _). % Пустое множество — подмножество любого
subset([X|Xs], Ys) :-
    member(X, Ys), % Проверяем, что X есть в Ys
    subset(Xs, Ys). % Рекурсивно проверяем остальные элементы

% Проверка уникальности элементов
all_unique([]). % Пустой список уникален
all_unique([X|Xs]) :-
    \+ member(X, Xs), % X не должен встречаться в Xs
    all_unique(Xs). % Проверяем хвост списка

% Чтение списка с клавиатуры и проверка уникальности
read_unique_list(Prompt, List) :-
    repeat, % Повторяем, пока не получим корректный ввод
    write(Prompt),
    read_line_to_string(user_input, Input),
    split_string(Input, " \t", "", StringList),
    maplist(atom_to_term, StringList, TempList, _),
    (   TempList \= [], % Список не пустой
        all_unique(TempList) % Все элементы уникальны
    ->  List = TempList % Успех — возвращаем список
    ;   writeln('Ошибка: элементы должны быть уникальны и не пусты!'),
        fail % Повторяем ввод
    ).

% Основная логика программы
start2 :-
    nl, write('=== Проверка подмножеств (без повторений) ==='), nl, nl,
    
    % Ввод первого множества
    read_unique_list('Введите первое множество (элементы через пробел): ', Xs),
    
    % Ввод второго множества
    read_unique_list('Введите второе множество (элементы через пробел): ', Ys),
    
    % Проверка подмножеств и вывод
    nl, write('Результат:'), nl,
    (   subset(Xs, Ys)
    ->  format('~w ⊆ ~w~n', [Xs, Ys])
    ;   write('Первое множество НЕ является подмножеством второго'), nl
    ),
    (   subset(Ys, Xs)
    ->  format('~w ⊆ ~w~n', [Ys, Xs])
    ;   write('Второе множество НЕ является подмножеством первого'), nl
    ),
    (   (subset(Xs, Ys) ; subset(Ys, Xs))
    ->  writeln('Вывод: одно множество является подмножеством другого')
    ;   writeln('Вывод: ни одно не является подмножеством другого')
    ).

:- initialization(start2).






% Список детей и городов
children([alik, borya, vitia, lena, dasha]).
cities([kharkiv, uman, poltava, slavyansk, kramatorsk]).

% Предикат распределения: child_city(Child, City)
solution(ChildCity) :-
    children(Children),
    cities(Cities),
    % Создаем список пар [Ребенок-Город]
    assign_cities(Children, Cities, ChildCity),
    
    % Проверяем условия
    condition1(ChildCity),
    condition2(ChildCity),
    condition3(ChildCity),
    condition4(ChildCity).

% Распределяем города детям без повторений
assign_cities([], _, []).
assign_cities([Child|RestChildren], Cities, [Child-City|RestAssign]) :-
    select(City, Cities, RemainingCities), % Выбираем город
    assign_cities(RestChildren, RemainingCities, RestAssign).

% Условие 1: Если Алик не из Умани, то Боря из Краматорска
condition1(ChildCity) :-
    (member(alik-uman, ChildCity) -> true ; member(borya-kramatorsk, ChildCity)).

% Условие 2: Либо Боря, либо Витя из Харькова
condition2(ChildCity) :-
    (member(borya-kharkiv, ChildCity) ; member(vitia-kharkiv, ChildCity)),
    \+ (member(borya-kharkiv, ChildCity), member(vitia-kharkiv, ChildCity)).

% Условие 3: Если Витя не из Славянска, то Лена из Харькова
condition3(ChildCity) :-
    (member(vitia-slavyansk, ChildCity) -> true ; member(lena-kharkiv, ChildCity)).

% Условие 4: Либо Даша из Умани, либо Лена из Краматорска
condition4(ChildCity) :-
    (member(dasha-uman, ChildCity) ; member(lena-kramatorsk, ChildCity)).

% Запуск решения
:- initialization(run, after_load).

run :-
    solution(ChildCity),
    format('Распределение:~n'),
    maplist(print_pair, ChildCity).

print_pair(Child-City) :-
    atom_string(Child, ChildStr),
    atom_string(City, CityStr),
    format('~w: ~w~n', [ChildStr, CityStr]).