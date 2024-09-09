//
//  CalendarDate.swift
//  PeriodTracker
//
//  Created by Denis Khlopin on 04.09.2024.
//

import Foundation


/// Фазы менструального цикла
/// > Менструальная фаза (1-5 день): Начинается с первого дня менструации, когда эндометрий (внутренний слой матки)
/// отторгается и выходит из организма через влагалище. Кровотечение может длиться от 3 до 7 дней.
///
/// > Фолликулярная фаза (1-13 день): Эта фаза начинается одновременно с менструальной фазой. Гормон ФСГ
/// (фолликулостимулирующий гормон) стимулирует созревание фолликулов в яичниках. Эстроген начинает подниматься, что
/// помогает подготовить эндометрий к возможной беременности.
///
/// > Овуляция (около 14 дня): Один из самых важных дней — овуляция. Под влиянием ЛГ (лютеинизирующего гормона)
/// созревший фолликул лопается, и яйцеклетка выходит из яичника. Этот период наиболее благоприятен для зачатия,
/// так как яйцеклетка живет около 24 часов.
///
/// > Лютеиновая фаза (15-28 день): После овуляции уровень прогестерона возрастает, и эндометрий начинает
/// утолщаться, готовясь к возможной имплантации оплодотворенной. Если беременность не наступает, уровень гормонов
/// падает, и цикл начинается снова с менструальной фазы.
///
/// Важные дни:
/// > Овуляция (около 14 дня): самый благоприятный день для зачатия.
///
/// > 5-7 день до овуляции: тоже период с повышенной вероятностью зачатия, так как сперматозоиды могут жить в
/// женском организме до 5 дней.
///
/// > ПМС (последние 3-7 дней цикла): может появляться раздражительность, усталость, изменение настроения из-за
/// гормональных колебаний.
///
/// - Parameters:
///     - menstruation: Менструальная фаза (1-5 день)
///     - follicular: Фолликулярная фаза (1-13 день):
///     - ovulation: Овуляция (около 14 дня)
///     - luteal: Лютеиновая фаза (15-28 день)
enum MenstrualCyclePhase {
    case menstruation
    case follicular
    case ovulation
    case luteal
}
/// Текущие расчитанные(предсказанные) параметры менструального цикла
/// - Parameters:
///     - beginningOfTheLastMenstrualCycle: Первый день последнего зарегистрированного менструального цикла
///     - menstrualFullCycleLength: Среднее значение длительности менструального цикла в днях. По умолчанию 28 (21 - 35)
///     - menstrualPhaseLength: Среднее значение длительности фазы менструации в днях. 
///     Исчисляется от начала цикла. По умолчанию 5.
///     - ovulationDay: Рассчетный день овуляции от начала периода. По умолчанию 14
///     - fertileDaysBeforeOvulation: Количество благоприятных дней перед овуляцией. По умолчанию 7
///     - fertileDaysAfterOvulation: Количество благоприятных дней до овуляции. По умолчанию 2
struct MenstrualCycleParameters {

    let beginningOfTheLastMenstrualCycle: Date
    let menstrualFullCycleLength: Int
    let menstrualPhaseLength: Int

    let ovulationDay: Int
    let fertileDaysBeforeOvulation: Int
    let fertileDaysAfterOvulation: Int
}

struct MenstrualPeriod {
    let startDate: Date
    let cycleLength: Date

    let menstruationDays: [Date]
    let ovulationDate: Date
    let fertileDates: [Date]
}

// Эксперимента на фло
// menstrualFullCycleLength = 20 => ovulationDay = 13 goodDaysBeforeOvulation = 7 goodDaysAfterOvulation = 2
// menstrualFullCycleLength = 28 => ovulationDay = 14 goodDaysBeforeOvulation = 7 goodDaysAfterOvulation = 2
// menstrualFullCycleLength = 30 => ovulationDay = 15 goodDaysBeforeOvulation = 7 goodDaysAfterOvulation = 2
// menstrualFullCycleLength = 40 => ovulationDay = 26 goodDaysBeforeOvulation = 7 goodDaysAfterOvulation = 2

// если задавать длинный цикл, то фло берет дефолтные настройки для 28 дней

// 1) у нас есть массив дат месячных, это входные(исходные) данные
var menstrualDates: [Date] = []
// 2) эти даты нужно сгруппировать в месячные циклы, это будет массив из следующих структур
struct MenstruationPeriod {
    let startDate: Date // первый день цикла
    let otherDates: [Date] // другие дни цикла менструации
    let length: Int // длина полного цикла

    let ovulationDay: Int // день овуляции, начиная с начала текущего цикла
    let fertileDaysBeforeOvulation: Int // Количество благоприятных дней перед овуляцией
    let fertileDaysAfterOvulation: Int // Количество благоприятных дней после овуляции
}
// цикл менструации не может быть меньше 20 дней и больше 35, все такие циклы нужно
