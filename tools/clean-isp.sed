# Skipping some fields
/\<rkn:territory\>/d;
/\<rkn:inn\>/d;

# Clean XML
s/^.*\<rkn:[a-z\_]\+\>\(.*\)\<rkn:[a-z\_]\+\>.*$/\1/g;

# Clean symbols
s/ \{2,\}/ /g;
s/&[a-zA-Z]\+;//g;
s/[^a-zA-Zа-яА-Я0-9 \,\.\:\;\-]//g;

# Clean property
s/\(ОАО\|ООО\|ПАО\|ЗАО\|АО\|ГОУ\|ВПО\) \{0,\}//gi;
s/^Общество с ограниченной ответственностью \{0,\}//gi;
s/^Открытое акционерное общество \{0,\}//gi;
s/^Публичное акционерное общество \{0,\}//gi;
s/^Закрытое акционерное общество \{0,\}//gi;
s/^Индивидуальный предприниматель \{0,\}//gi;
s/^Акционерное общество \{0,\}//gi;
s/^федеральное государственное бюджетное образовательное учреждение высшего образования \{0,\}//gi;
s/^Федеральное государственное автономное образовательное учреждение высшего образования \{0,\}//gi;

# Fine tuning
s/Невод Регион\|Невод-Регион/Невод-Регион/gi
s/Эр-Телеком Холдинг/ЭР-Телеком Холдинг/gi
s/Научно-производственное предприятие/НПП/gi
s/УНИКО/Унико/gi
s/Мегафон/Мегафон/gi
s/Тищук Валерий Леонидович/ИП Тищук В.Л./gi
s/Бизнес - системы/Бизнес-Системы/gi
s/бизнес-системы/Бизнес-Системы/gi
s/ВОЛГА-СВЯЗЬ-ТВ/Волга-Связь-ТВ/gi
s/Вымпел-Коммуникации/ВымпелКом/gi
s/ИНСАТКОМ-В/Инсатком-В/gi
s/КОСМОПОЛИТ/Космополит/gi
s/Ланком/Ланком/gi
s/Связь-Информ/СвязьИнформ/gi
s/Спринт-Сеть/Спринт Сеть/gi
s/Компания Стар Лайн Волгоград/Стар Лайн Волгоград/gi
s/ЭРОС/Электронные Радио Оптические Системы/gi
s/Захаров Борис Петрович/ИП Захаров Б.П./gi
s/Кулинич Александр Александрович/ИП Кулинич А.А./gi
s/восток/Восток/gi
s/ит-сервис/ИТ-Сервис/gi
s/мбит-сити/МБит-сити/gi
s/мтс/Мобильные ТелеСистемы/gi
s/т2 мобайл/Т2 Мобайл/gi


# Print
/[a-zA-Zа-яА-Я \,]/s/.*/"\0"/g;
p;
