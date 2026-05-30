import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/dummy_menu_items.dart';
import 'widgets/budget_slider_card.dart';
import 'widgets/savings_tip_card.dart';
import 'widgets/meal_plan_card.dart';
import 'widgets/suggestion_meal_card.dart';

class ChopBudgetScreen extends StatefulWidget {
  const ChopBudgetScreen({Key? key}) : super(key: key);

  @override
  State<ChopBudgetScreen> createState() => _ChopBudgetScreenState();
}

class _ChopBudgetScreenState extends State<ChopBudgetScreen> {
  double dailyBudget = 3500;
  double spent = 1200;
  String selectedView = 'Daily Plan';

  @override
  Widget build(BuildContext context) {
    // Filter meals that fit the budget
    final suggestedMeals = dummyMenuItems
        .where((meal) => meal.price <= (dailyBudget - spent))
        .take(3)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Chop Budget',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.calculate_outlined,
              color: Color(0xFFF59E0B),
              size: 22,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Daily Plan / Weekly View Toggle
              Row(
                children: [
                  _buildViewTab('Daily Plan', selectedView == 'Daily Plan'),
                  const SizedBox(width: 12),
                  _buildViewTab('Weekly View', selectedView == 'Weekly View'),
                ],
              ),

              const SizedBox(height: 20),

              // Budget Slider Card
              BudgetSliderCard(
                budget: dailyBudget,
                spent: spent,
                onBudgetChanged: (value) {
                  setState(() {
                    dailyBudget = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              // Savings Tip
              const SavingsTipCard(
                tip:
                    'Ordering combo meals or family sizing for dinner can save you 15% on average!',
              ),

              const SizedBox(height: 24),

              // Today's Plan
              const Text(
                'Today\'s Plan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 16),

              // Breakfast
              MealPlanCard(
                mealType: 'Breakfast',
                mealName: 'Akara & Pap',
                time: '8:30 AM',
                price: 1200,
                onAdd: () {},
              ),

              // Lunch (empty)
              MealPlanCard(mealType: 'Lunch', onAdd: () {}),

              // Dinner (empty)
              MealPlanCard(mealType: 'Dinner', onAdd: () {}),

              const SizedBox(height: 24),

              // Suggestions for Lunch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Suggestions for Lunch',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Refresh',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Suggested Meals
              ...suggestedMeals.map((meal) {
                return SuggestionMealCard(
                  meal: meal,
                  onAdd: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${meal.name} added to cart'),
                        duration: const Duration(seconds: 1),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                );
              }).toList(),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewTab(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedView = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.border : Colors.transparent,
            width: 0.5,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
