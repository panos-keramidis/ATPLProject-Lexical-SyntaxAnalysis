import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.*;

public class SPL {

	public static class MyErrorListener extends BaseErrorListener {

		@Override
		public void syntaxError(Recognizer<?, ?> recognizer,
				Object offendingSymbol,
				int line, int charPositionInLine,
				String msg,
				RecognitionException e) {
			List<String> stack = ((Parser) recognizer).getRuleInvocationStack();
			Collections.reverse(stack);
			System.err.println("rule stack: " + stack);
			System.err.println("line " + line + ":" + charPositionInLine + " at " + offendingSymbol + ": " + msg);
            System.exit(0); // Έξοδος από το πρόγραμμα στον πρώτο λανθασμένο κανόνα που θα βρεθεί
		}

	}

	public static void main(String[] args) throws Exception {
		/* Αν δοθεί αρχείο ως παράμετρος κατά την εκτέλεση θα χρησιμοποιήσει
           το αρχείο, αλλιώς θα διαβάζει από την είσοδο */
		String inputFile = null;
		if (args.length > 0) {
			inputFile = args[0];
		}

		InputStream inStream;

		if (inputFile != null) {
			inStream = new FileInputStream(inputFile);
		} else {
			inStream = System.in;
		}

		// Δημιουργία ενός stream χαρακτήρων από την είσοδο
		ANTLRInputStream input = new ANTLRInputStream(inStream);

		// Δημιουργεί ένα αντικείμενο λεκτικού αναλυτή
		// Προσοχή στο όνομα της κλάσης, εξαρτάται από το όνομα της γραμματικής (PlayChecker στην προκειμένη περίπτωση)
		SPLLexer lexer = new SPLLexer(input);

		// Δημιουργεί μια ενδιάμεση μνήμη (buffer) για τις λεκτικές μονάδες (tokens)
		CommonTokenStream tokens = new CommonTokenStream(lexer);

		// Δημιουργεί ένα αντικείμενο συντακτικού αναλυτή που τροφοδοτείται από τα tokens
		// Προσοχή στο όνομα της κλάσης, εξαρτάται από το όνομα της γραμματικής (PlayChecker στην προκειμένη περίπτωση)
		SPLParser parser = new SPLParser(tokens);

        parser.removeErrorListeners(); // Αφαίρεση προκαθορισμένου ConsoleErrorListener
        parser.addErrorListener(new MyErrorListener()); // προσθήκη του δικού μας

		// Η ανίχνευση ξεκινάει από τον κανόνα stat
		ParseTree tree = parser.stat();
	}
}
