import 'package:cinema_app/features/tickets/data/models/ticket_model.dart';
import 'package:cinema_app/features/tickets/presentation/providers/tickets_provider.dart';
import 'package:cinema_app/features/tickets/presentation/widgets/cancel_ticket_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../widgets/ticket_item_widget.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TicketsProvider>(context, listen: false).loadUserTickets();
    });
  }
  void _showCancelDialog(BuildContext context, Ticket ticket) {
  final dateFormat = DateFormat('MMM dd, yyyy');
  final formattedDate = dateFormat.format(ticket.dateTime);

  showDialog(
    context: context,
    builder: (context) => CancelTicketDialog(
      movieName: ticket.movieName,
      date: formattedDate,
      onConfirm: () => _cancelTicket(context, ticket),
    ),
  );
}

Future<void> _cancelTicket(BuildContext context, Ticket ticket) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  // Store the messenger reference before the async operation
  final messenger = ScaffoldMessenger.of(context);

  try {
    final dateParts = ticket.date.split('/');
    final date = DateTime(
      int.parse(dateParts[2]),
      int.parse(dateParts[1]),
      int.parse(dateParts[0]),
    );

    await context.read<TicketsProvider>().cancelTicket(
      bookingId: ticket.id,
      userId: user.uid,
      movieId: ticket.movieId,
      cinemaId: ticket.cinemaId,
      date: date,
      time: ticket.time,
      seats: ticket.seats,
    );

    messenger.showSnackBar(
      SnackBar(content: Text('Ticket cancelled successfully')),
    );
  } catch (e) {
    messenger.showSnackBar(
      SnackBar(content: Text('Failed to cancel ticket: ${e.toString()}')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final ticketsProvider = Provider.of<TicketsProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        context.go('/home');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Tickets'),
          backgroundColor: const Color(0xFF121212),
          foregroundColor: Colors.green,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/home'),
          ),
        ),
        body: ticketsProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ticketsProvider.tickets.isEmpty
                ? const Center(
                    child: Text(
                      'You don\'t have any tickets yet',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: ticketsProvider.tickets.length,
                    itemBuilder: (context, index) {
                      final ticket = ticketsProvider.tickets[index];
                      return TicketItemWidget(
                        ticket: ticket,
                        onTap: () => context.go('/ticket-detail', extra: ticket),
                         onDelete: (context) => _showCancelDialog(context, ticket), // Keep empty for now
                      );
                    },
                  ),
      ),
    );
  }
}